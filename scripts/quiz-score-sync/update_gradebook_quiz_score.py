#!/usr/bin/env python3

import argparse
import pandas as pd
import os
import sys
import logging
import re


def setup_logging(log_file='script.log'):
    """
    Configures the logging settings to log messages to both a file and the console.
    """
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file, mode='w'),  # Log to script.log
            logging.StreamHandler(sys.stdout)         # Also log to console
        ]
    )


def parse_arguments():
    """
    Parses command-line arguments provided by the user.
    """
    parser = argparse.ArgumentParser(
        description='Upload PrairieLearn quiz scores to bCourses and generate reports.'
    )
    parser.add_argument(
        'quiz_scores_csv',
        type=str,
        help='Path to the PrairieLearn quiz scores CSV file.'
    )
    parser.add_argument(
        'gradebook_csv',
        type=str,
        help='Path to the bCourses gradebook CSV file.'
    )
    parser.add_argument(
        '--output-dir',
        type=str,
        default='output',
        help='Directory to save the updated gradebook and reports.'
    )
    return parser.parse_args()


def load_csv(file_path, required_columns=None):
    """
    Loads a CSV file into a pandas DataFrame, ensuring required columns are present.
    """
    if not os.path.exists(file_path):
        logging.error(f'File not found: {file_path}')
        sys.exit(1)
    try:
        df = pd.read_csv(file_path, dtype=str)  # Ensure all data is read as strings
        if required_columns:
            missing = set(required_columns) - set(df.columns)
            if missing:
                logging.error(f'Missing columns {missing} in {file_path}')
                sys.exit(1)
        return df
    except Exception as e:
        logging.error(f'Error reading {file_path}: {e}')
        sys.exit(1)


def validate_quiz_scores_df(df):
    """
    Validates the structure of the quiz scores DataFrame.
    Ensures required columns are present and only one quiz score column exists.
    """
    required_columns = {'UIN', 'UID'}
    # 'UID' is present but not required for processing
    if not required_columns.issubset(df.columns):
        missing = required_columns - set(df.columns)
        logging.error(f'Quiz scores CSV is missing required columns: {missing}')
        sys.exit(1)
    # Identify quiz score columns by excluding required and non-quiz columns
    non_quiz_columns = {'UID'}
    quiz_columns = [col for col in df.columns if col not in required_columns and col not in non_quiz_columns]
    if len(quiz_columns) != 1:
        logging.error(f'Expected exactly one quiz score column, found {len(quiz_columns)}: {quiz_columns}')
        sys.exit(1)
    quiz_name = quiz_columns[0]
    logging.info(f'Detected quiz name: "{quiz_name}"')
    return quiz_name


def detect_gradebook_quiz_column(gradebook_df, quiz_name):
    """
    Detects the corresponding quiz column in the gradebook DataFrame using regex.
    Only matches columns with the exact format: Quiz X (number)
    """
    # Define regex pattern to match "Quiz X (number)" exactly
    pattern = re.compile(rf'^{re.escape(quiz_name)} \(\d+\)$')
    matching_columns = [col for col in gradebook_df.columns if pattern.match(col)]

    if not matching_columns:
        logging.error(f'No matching gradebook column found for quiz "{quiz_name}" with pattern "{pattern.pattern}".')
        logging.error('Please ensure that the gradebook contains a column in the format "Quiz X (number)".')
        sys.exit(1)
    elif len(matching_columns) == 1:
        gradebook_quiz_column = matching_columns[0]
        logging.info(f'Auto-detected gradebook column: "{gradebook_quiz_column}"')
        return gradebook_quiz_column
    else:
        # If multiple exact matches are found, select the first one and log a warning
        gradebook_quiz_column = matching_columns[0]
        logging.warning(f'Multiple gradebook columns found for quiz "{quiz_name}": {matching_columns}.')
        logging.warning(f'Selecting the first match "{gradebook_quiz_column}".')
        return gradebook_quiz_column


def update_gradebook(gradebook_df, quiz_scores_df, quiz_name, gradebook_quiz_column):
    """
    Merges the quiz scores into the gradebook DataFrame and updates the relevant quiz grade column.
    """
    # Clean column names by stripping whitespace
    quiz_scores_df = quiz_scores_df.rename(columns=lambda x: x.strip())
    gradebook_df = gradebook_df.rename(columns=lambda x: x.strip())

    # Ensure necessary columns exist
    if 'SIS Login ID' not in gradebook_df.columns:
        logging.error('Gradebook missing "SIS Login ID" column.')
        sys.exit(1)
    if 'UIN' not in quiz_scores_df.columns:
        logging.error('Quiz scores missing "UIN" column.')
        sys.exit(1)

    # Convert IDs to string for accurate merging and strip whitespace
    gradebook_df['SIS Login ID'] = gradebook_df['SIS Login ID'].astype(str).str.strip()
    quiz_scores_df['UIN'] = quiz_scores_df['UIN'].astype(str).str.strip()

    # Normalize IDs (e.g., remove leading zeros if necessary)
    # If UINs can have leading zeros, ensure both are treated consistently
    # Example: gradebook_df['SIS Login ID'] = gradebook_df['SIS Login ID'].str.lstrip('0')
    # quiz_scores_df['UIN'] = quiz_scores_df['UIN'].str.lstrip('0')

    # Check for leading/trailing spaces
    gradebook_df['SIS Login ID'] = gradebook_df['SIS Login ID'].str.strip()
    quiz_scores_df['UIN'] = quiz_scores_df['UIN'].str.strip()

    # Check for duplicates and warn
    if quiz_scores_df['UIN'].duplicated().any():
        logging.warning('Duplicate UINs found in quiz scores CSV.')
    if gradebook_df['SIS Login ID'].duplicated().any():
        logging.warning('Duplicate SIS Login IDs found in gradebook CSV.')

    # Display unique counts for debugging
    unique_quiz_scores = quiz_scores_df['UIN'].nunique()
    unique_gradebook_ids = gradebook_df['SIS Login ID'].nunique()
    logging.info(f'Unique UINs in quiz scores: {unique_quiz_scores}')
    logging.info(f'Unique SIS Login IDs in gradebook: {unique_gradebook_ids}')

    # Display sample UINs and SIS Login IDs for debugging
    logging.info(f'Sample UINs from quiz scores: {quiz_scores_df["UIN"].head().tolist()}')
    logging.info(f'Sample SIS Login IDs from gradebook: {gradebook_df["SIS Login ID"].head().tolist()}')

    # Merge quiz scores into gradebook based on SIS Login ID and UIN
    merged_df = gradebook_df.merge(
        quiz_scores_df[['UIN', quiz_name]],
        left_on='SIS Login ID',
        right_on='UIN',
        how='left',
        suffixes=('', '_quiz')
    )

    # Calculate number of matches
    num_matches = merged_df[quiz_name].notna().sum()
    total_quiz_scores = quiz_scores_df.shape[0]
    logging.info(f'Number of matched quiz scores: {num_matches} out of {total_quiz_scores}')

    # Update the quiz grade column in the gradebook
    merged_df[gradebook_quiz_column] = merged_df[quiz_name]
    logging.info(f'Updated column "{gradebook_quiz_column}" with quiz scores.')

    # Drop unnecessary columns used for merging
    merged_df.drop(columns=['UIN', quiz_name], inplace=True)

    return merged_df


def generate_reports(merged_df, quiz_scores_df, gradebook_quiz_column, output_dir, quiz_name):
    """
    Generates a report detailing students who haven't taken the quiz and any anomalies.
    """
    # Students who haven't taken the quiz
    not_taken = merged_df[merged_df[gradebook_quiz_column].isna()]
    num_not_taken = not_taken.shape[0]
    logging.info(f'Number of students who have not taken {quiz_name}: {num_not_taken}')

    # Students in quiz scores but not in gradebook (anomalies)
    unmatched = quiz_scores_df[~quiz_scores_df['UIN'].isin(merged_df['SIS Login ID'])]
    num_unmatched = unmatched.shape[0]
    logging.info(f'Number of anomalies (students in quiz scores but not in gradebook): {num_unmatched}')

    # Save report
    report_path = os.path.join(output_dir, 'reports.txt')
    with open(report_path, 'w') as report_file:
        # Header
        report_file.write(f'Report for {quiz_name}\n')
        report_file.write('='*50 + '\n\n')

        # Summary
        report_file.write(f'Total students in gradebook: {merged_df.shape[0]}\n')
        report_file.write(f'Students who have not taken {quiz_name}: {num_not_taken}\n')
        report_file.write(f'Anomalies (in quiz scores but not in gradebook): {num_unmatched}\n\n')

        # List of students who have not taken the quiz
        if num_not_taken > 0:
            report_file.write('List of students who have not taken the quiz:\n')
            # Define column widths
            sis_login_id_width = 20
            student_width = 35
            # Write header
            report_file.write(f'{"SIS Login ID":<{sis_login_id_width}} {"Student":<{student_width}}\n')
            # Write separator
            report_file.write(f'{"-"*sis_login_id_width} {"-"*student_width}\n')
            # Iterate over not_taken DataFrame
            for _, row in not_taken.iterrows():
                sis_login_id = row['SIS Login ID'] if pd.notna(row['SIS Login ID']) else ''
                student = row['Student'] if pd.notna(row['Student']) else ''
                report_file.write(f'{sis_login_id:<{sis_login_id_width}} {student:<{student_width}}\n')
            report_file.write('\n')

        # List of anomalies
        if num_unmatched > 0:
            report_file.write('Anomalies (students in quiz scores but not in gradebook):\n')
            # Define column width
            uin_width = 20
            # Write header
            report_file.write(f'{"UIN":<{uin_width}}\n')
            # Write separator
            report_file.write(f'{"-"*uin_width}\n')
            # Iterate over unmatched DataFrame
            for _, row in unmatched.iterrows():
                uin = row['UIN'] if pd.notna(row['UIN']) else ''
                report_file.write(f'{uin:<{uin_width}}\n')
            report_file.write('\n')

    logging.info(f'Report generated at {report_path}')


def save_updated_gradebook(updated_df, output_dir):
    """
    Saves the updated gradebook DataFrame to a CSV file in the specified output directory.
    """
    output_path = os.path.join(output_dir, 'updated_gradebook_with_quiz_score.csv')
    try:
        updated_df.to_csv(output_path, index=False)
        logging.info(f'Updated gradebook saved to {output_path}')
    except Exception as e:
        logging.error(f'Failed to save updated gradebook: {e}')
        sys.exit(1)


def main():
    """
    Main function to orchestrate the gradebook update and report generation process.
    """
    args = parse_arguments()
    os.makedirs(args.output_dir, exist_ok=True)
    setup_logging(os.path.join(args.output_dir, 'script.log'))  # Initialize logging here

    logging.info('Loading gradebook...')
    gradebook_df = load_csv(args.gradebook_csv, required_columns=['SIS Login ID', 'Student'])

    logging.info('Loading quiz scores...')
    quiz_scores_df = load_csv(args.quiz_scores_csv, required_columns=['UIN', 'UID'])

    logging.info('Validating quiz scores CSV...')
    quiz_name = validate_quiz_scores_df(quiz_scores_df)

    logging.info('Detecting corresponding gradebook column...')
    gradebook_quiz_column = detect_gradebook_quiz_column(gradebook_df, quiz_name)

    logging.info('Updating gradebook with quiz scores...')
    updated_gradebook = update_gradebook(
        gradebook_df,
        quiz_scores_df,
        quiz_name,
        gradebook_quiz_column
    )

    logging.info('Generating reports...')
    generate_reports(updated_gradebook, quiz_scores_df, gradebook_quiz_column, args.output_dir, quiz_name)

    logging.info('Saving updated gradebook...')
    save_updated_gradebook(updated_gradebook, args.output_dir)

    logging.info('Process completed successfully.')


if __name__ == '__main__':
    main()

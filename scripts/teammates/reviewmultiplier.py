"""
Takes in an exported .csv file from https://teammatesv4.appspot.com and outputs
a .csv file (multipliers.csv) of multipliers to assign student grades to. Also outputs
question-by-question breakdowns.

How to call from command line:
python3 peer_multiplier.py <filepath of TEAMMATES.org exported csv>
"""

import csv, re, sys, os, datetime, pandas as pd

def main(): 
    filepath = str(sys.argv[1])
    equalize_csv(filepath)
    questions_list = split_csv(filepath)
    folder_name = str(datetime.datetime.now().replace(microsecond = 0))
    os.mkdir(folder_name)
    multiplier_df = pd.DataFrame()
    for question in questions_list: #Recombining the csv's after they've been split by question to give equal weighting
        calculate_multiplier(question)
        os.rename(question, os.path.join(folder_name, question))
        if len(multiplier_df) == 0:
            multiplier_df = pd.read_csv(os.path.join(folder_name, question))
        else:
            question_df = pd.read_csv(os.path.join(folder_name, question))
            multiplier_df = multiplier_df.merge(question_df, left_on = ["Team", "Recipient", "Recipient Email"], right_on = ["Team", "Recipient", "Recipient Email"])
    multiplier_df["Multiplier"] = multiplier_df[['Multiplier_x', 'Multiplier_y']].mean(axis=1).round(2) #Future improvements: Need to delete the dependence on the column names being "Multiplier_x"
    multiplier_df = multiplier_df.drop(["Multiplier_x", "Multiplier_y"], axis = 1)
    with open(os.path.join(folder_name, "multipliers.csv"), 'w', newline='') as file:
        output_csv = multiplier_df.to_csv(index=False)
        file.write(output_csv)


def equalize_csv(filepath): #Adds commas to a csv file to equalize column length
    # Step 1: Read the CSV file and determine the maximum number of entries in a row
    with open(filepath, 'r') as file:
        reader = csv.reader(file)
        rows = list(reader)
    
    max_entries = max(len(row) for row in rows)

    # Step 2: Iterate over the rows and append empty values to make them equal length
    equalized_rows = []
    for row in rows:
        diff = max_entries - len(row)
        equalized_row = row + [''] * diff
        equalized_rows.append(equalized_row)

    # Step 3: Write the updated rows to a new CSV file
    with open(filepath, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerows(equalized_rows)

def split_csv(filepath): #Takes in a TEAMMATES csv file and splits it into relevant questions
    outputFilepaths = []
    with open(filepath, 'r') as file:
        lines = file.readlines()

    header = lines[0]  # Assuming the first line is the header

    question_indices = [i for i, line in enumerate(lines[1:], start=1) if re.search('Question\s\d+', line)]
    
    question_count = 0

    for i in range(len(question_indices)):
        question_index = question_indices[i]
        if len(lines) < question_index + 3 or 'Summary Statistics' not in lines[question_index + 2]:
            continue

        question_count += 1
        destinationpath = f'{datetime.datetime.now().replace(microsecond = 0)}question_{question_count}.csv'
        outputFilepaths.append(destinationpath)
        with open(destinationpath, 'w') as output_file:
            output_file.write(header)
            output_file.write(lines[question_index])

            team_indices = [j for j, line in enumerate(lines[question_index + 1:], start=question_index + 1) if 'Team' in line]
            if len(team_indices) >= 2:
                second_team_index = team_indices[1]
            else:
                second_team_index = len(lines)

            for line in lines[question_index + 1:second_team_index]:
                output_file.write(line)
    return outputFilepaths

def calculate_multiplier(filepath): #Takes in a TEAMMATES .CSV file and outputs a .CSV file with the multipliers calculated
    csv_converted = pd.read_csv(filepath)
    
    team_index = csv_converted.index[csv_converted.iloc[:, 0].str.contains('Team', na=False)].tolist()[0]
    df = csv_converted.iloc[team_index:]
    df = df.rename(columns=df.iloc[0]).drop(df.index[0]).reset_index(drop=True)
    
    relevant_columns = ["Team", "Recipient", "Recipient Email", "Total Points", "Average Points"]
    df = df[relevant_columns].dropna(how='all')
    df["Average Points"] = df["Average Points"].astype(float).astype(int)
    
    team_count = df.groupby('Team')['Team'].transform('count')
    df["Multiplier"] = df["Average Points"] / (1 / team_count) / 100
    df = df.drop(columns = ["Total Points", "Average Points"]).sort_values("Recipient")

    output_csv = df.to_csv(index=False)
    with open(filepath, 'w') as output_file:
        output_file.write(output_csv)

main()

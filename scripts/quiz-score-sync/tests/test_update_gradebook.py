#!/usr/bin/env python3

import unittest
import subprocess
import os
import sys
import filecmp
import difflib
import tempfile


class TestUpdateGradebook(unittest.TestCase):
    def setUp(self):
        """
        Set up the test environment by defining paths.
        """
        # Define paths to the main script and test data
        self.script_path = os.path.abspath('../update_gradebook_quiz_score.py')  # Path to the main script

        # Input files
        self.input_gradebook = os.path.abspath('data/input_sanitized/sanitized_student_gradebook.csv')
        self.input_quiz = os.path.abspath('data/input_sanitized/sanitized_quiz_data.csv')

        # Expected output files
        self.expected_report = os.path.abspath('data/expected_output_sanitized/reports.txt')
        self.expected_gradebook = os.path.abspath('data/expected_output_sanitized/updated_gradebook_with_quiz_score.csv')

        # Ensure expected output files exist
        self.assertTrue(os.path.isfile(self.expected_report), f'Expected report file not found: {self.expected_report}')
        self.assertTrue(os.path.isfile(self.expected_gradebook), f'Expected gradebook CSV file not found: {self.expected_gradebook}')

    def run_script(self, temp_output_dir):
        """
        Executes the update_gradebook_quiz_score.py script with the test inputs.
        """
        try:
            subprocess.run([
                sys.executable,  # Use the current Python interpreter
                self.script_path,
                self.input_quiz,
                self.input_gradebook,
                '--output-dir',
                temp_output_dir
            ], check=True)
        except subprocess.CalledProcessError as e:
            self.fail(f'Script execution failed: {e}')

    def compare_files(self, actual, expected):
        """
        Compares two files and returns True if they are identical, False otherwise.
        If they differ, prints the differences.
        """
        if filecmp.cmp(actual, expected, shallow=False):
            return True
        else:
            # Read the files
            with open(actual, 'r') as f_actual, open(expected, 'r') as f_expected:
                actual_lines = f_actual.readlines()
                expected_lines = f_expected.readlines()

            # Generate a unified diff
            diff = difflib.unified_diff(
                expected_lines,
                actual_lines,
                fromfile='expected',
                tofile='actual',
                lineterm=''
            )

            # Format the diff
            diff_text = '\n'.join(diff)
            self.fail(f'Files {actual} and {expected} differ:\n{diff_text}')

    def test_reports_txt(self):
        """
        Test that the generated reports.txt matches the expected reports.txt.
        """
        with tempfile.TemporaryDirectory() as temp_output_dir:
            self.run_script(temp_output_dir)

            actual_report = os.path.join(temp_output_dir, 'reports.txt')

            # Check if the actual report file was created
            self.assertTrue(os.path.isfile(actual_report), f'Actual report file not found: {actual_report}')

            # Compare the files
            self.compare_files(actual_report, self.expected_report)

    def test_updated_gradebook_csv(self):
        """
        Test that the generated updated_gradebook_with_quiz_score.csv matches the expected CSV.
        """
        with tempfile.TemporaryDirectory() as temp_output_dir:
            self.run_script(temp_output_dir)

            actual_gradebook = os.path.join(temp_output_dir, 'updated_gradebook_with_quiz_score.csv')

            # Check if the actual gradebook CSV file was created
            self.assertTrue(os.path.isfile(actual_gradebook), f'Actual gradebook CSV file not found: {actual_gradebook}')

            # Compare the files
            self.compare_files(actual_gradebook, self.expected_gradebook)


if __name__ == '__main__':
    unittest.main()

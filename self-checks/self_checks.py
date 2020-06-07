from canvasapi import Canvas
from requests.compat import urljoin
import argparse, json, requests

###### ENTER YOUR VALUES HERE ######

API_URL = "REPLACE"   # i.e. "https://bcourses.berkeley.edu/"
API_KEY = "REPLACE"   # To obtain API key, see this: https://community.canvaslms.com/docs/DOC-14409-4214861717
COURSE_ID = 0         # Should be a number i.e. 123456789
USER_ID = 0           # Should be a number i.e. 123456789
ASSIGNMENTS_GROUP = 0 # (Optional, set to 0 if not needed) Should be a number i.e. 123456789

####################################

# Print list of IDs of all assignment group
def get_assignment_groups():
    canvas = Canvas(API_URL, API_KEY)
    course = canvas.get_course(COURSE_ID)
    for group in list(course.get_assignment_groups()):
        print(group)

# Delete all quizzes with IDs in the range of "start" to "finish"
def delete_quizzes(start, finish):
    canvas = Canvas(API_URL, API_KEY)
    course = canvas.get_course(COURSE_ID)
    for id in range(start, finish+1):
        quiz = course.get_quiz(id)
        response = quiz.delete()
        print(response)

# Create a quiz with given title and list of questions
def create_quiz(title, questions):
    canvas = Canvas(API_URL, API_KEY)
    course = canvas.get_course(COURSE_ID)
    print("Creating quiz for: " + title)
    quiz_params = {
        "allowed_attempts": -1,
        "assignment_group_id": ASSIGNMENTS_GROUP,
        "description": "", # No description
        "published": True,
        "one_question_at_a_time": False,
        "quiz_type": "assignment",
        "scoring_policy": "keep_highest",
        "show_correct_answers": True,
        "shuffle_answers": True,
        "title": title,
    }
    quiz = course.create_quiz(quiz_params)
    print("Quiz ID: ", quiz)

    for question in questions:
        question_params = {
            "question_text": question["text"],
            "question_type": "multiple_choice_question",
            "points_possible": 1,
            "neutral_comments": question["explanation"],
            "answers": question["answer"]
        }
        response = quiz.create_question(question=question_params)

    return quiz

def create_quizzes():
    with open('self_checks.json') as f:
        data = json.load(f)

    f = open("quiz_IDs.txt", "w")
    for module in data:
        title = "Self-Check " + module["module"]
        questions = module["questions"]
        quiz = create_quiz(title, questions)
        f.write(str(quiz))
        f.write("\n")
    f.close()

if __name__ == '__main__':
    # Defining Arguments
    parser = argparse.ArgumentParser(description="Specify which function to run")
    parser.add_argument("-g", "--groups", help="Print list of assignment groups", action="store_true")
    parser.add_argument("-d", "--delete", type=int, nargs=2, metavar=('startID', 'endID'), help='Delete quizzes in specified range')
    parser.add_argument("-c", "--create", type=bool, default=False, help="Create quizzes from `self_checks.json` file")

    ARGS = parser.parse_args()

    if ARGS.groups:
        print("Hi")
        get_assignment_groups()
    elif ARGS.delete:
        print("Hi 2")
        startID, endID = ARGS.delete
        delete_quizzes(startID, endID)
    elif ARGS.create:
        print("Hi 3")
        create_quizzes()

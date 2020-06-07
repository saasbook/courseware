## Self Check Questions
This directory contains a compilation of self check questions for every submodule of the SaaS textbook, 2nd edition. It also contains code for deploying these questions to a Canvas based instructional course site.

`self_checks.json` contains the questions, formatted in JSON, organized in the following manner:
```
{
  "module": "Module Title",
  "questions": [
    {
      "text": "Question Text",
      "answer": [
        {
          "answer_text": "Answer 1",
          "answer_weight": 100
        },
        < More Answers Here (100 = Correct, 0 = Incorrect) >
      ],
      "explanation": "General explanation comment here"
    },
    < More Questions Here >
  ]
},
```
All self checks are single correct, multiple choice questions.

`self_checks.py` contains the code for propagating and deleting quizzes to and from the course website. This file can be executed with `python self_checks.py` with the following option flags:
* `-g`: Return all assignment group IDs of course
* `-d <startID> <endID>`: Delete all quizzes with IDs in [`startID`, `endID`]
* `-c`: Generates quizzes from `self_checks.json` content. One quiz will be created for each `module` block.

The generated quiz will have the following settings:
* Infinite allowed attempts
* No Description
* Automatically published
* "Keep Highest" Scoring Policy
* Shows correct answers upon completion
* Shuffles answer choices

Feel free to change these settings (corresponds to the `quiz_params` variable on line 37) as needed.

The `self_checks.py` functionality heavily relies on the University of Florida Canvas API ([link](https://readthedocs.org/projects/canvasapi/downloads/pdf/latest/)). If you'd like to contribute to this file with Canvas functionality you think is relevant, we'd recommend checking whether the API has an appropriate method call for your use case.

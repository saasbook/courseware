## Self Check Questions
This directory contains a compilation of self check questions for every submodule of the SaaS textbook, 2nd edition. It also contains code for deploying these questions to a Canvas based instructional course site.

### Question Bank

`self-checks.json` contains the questions, formatted in JSON, organized in the following manner:
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

### Code

`self-checks.py` contains the code for propagating and deleting quizzes to and from the course website. This file can be executed with `python self-checks.py` with the following option flags:
* `-g`: Return all assignment group IDs of course
* `-d <startID> <endID>`: Delete all quizzes with IDs in [`startID`, `endID`]
* `-c`: Generates quizzes from `self-checks.json` content. One quiz will be created for each `module` block. This command will also generate a `quiz_IDs.txt` file that contains the IDs corresponding to each newly created quiz. This is useful to keep in case one wants to delete the quizzes using the `-d` flag

The generated quiz will have the following settings:
* Infinite allowed attempts
* No Description
* Automatically published
* "Keep Highest" Scoring Policy
* Shows correct answers upon completion
* Shuffles answer choices

Feel free to change these settings (corresponds to the `quiz_params` variable on line 37) as needed.

The `self-checks.py` functionality heavily relies on the University of Florida Canvas API ([link](https://readthedocs.org/projects/canvasapi/downloads/pdf/latest/)). If you'd like to contribute to this file with Canvas functionality you think is relevant, we'd recommend checking whether the API has an appropriate method call for your use case.

### Images

At the moment, we have not figured out how to push images when generating quizzes through the API call. The `images` folder contains `.png` files named after the `<module>_<submodule>.png` they correspond to. Currently, these should be manually added to the quiz after it's published.

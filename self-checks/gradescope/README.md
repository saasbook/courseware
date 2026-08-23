# Gradescope Self-Checks

This directory converts the course's **Self-Check** questions from an
[IMS Common Cartridge](https://www.imsglobal.org/cc/index.html) (`.imscc`)
Canvas export into [Gradescope](https://www.gradescope.com)-compatible
Markdown, grouped one file per module.

## Contents

- **`imscc_to_gradescope.py`** — the extraction script.
- **`modules/`** — generated output: one `Module X Self-Checks.md` per module,
  plus an `images/` folder holding any images referenced by the questions.

## Usage

```bash
python3 imscc_to_gradescope.py path/to/course-export.imscc -o modules
```

`imscc_to_gradescope.py` accepts either the `.imscc`/`.zip` file or an
already-extracted cartridge directory. With no cartridge argument it looks for a
single `*.imscc` in the current directory. The script has **no third-party
dependencies** (standard library only).

What it does:

1. Reads `imsmanifest.xml` and finds every course item titled
   `Self-Check X.Y: <topic>`, resolving each to its QTI 1.2 assessment file.
2. Parses the QTI into questions — prompt, answer choices, the correct
   answer(s) (read from the QTI response-processing rules, **not** assumed to be
   the first choice), and any explanation feedback.
3. Converts the embedded HTML to Markdown and copies referenced images locally.
4. Writes one `Module X Self-Checks.md` per module, with questions separated by
   `---`.

## Gradescope Markdown format

The output uses Gradescope's online-assignment answer syntax so questions can be
autograded on import:

| Question type            | Syntax                                  |
| ------------------------ | --------------------------------------- |
| Multiple choice (single) | `( )` for options, `(x)` for the answer |
| Select all that apply    | `[ ]` for options, `[x]` for answers    |
| Free response            | prompt only (manually graded)           |

All current Self-Checks are single-answer multiple choice. Each question's
explanation is emitted as a Gradescope explanation line wrapped in `[[ ... ]]`.
Each explanation starts and ends on a single line; when a question has several,
each is written on its own `[[ ... ]]` line and Gradescope concatenates them.

To import: open (or create) a Gradescope Online Assignment and paste a module's
Markdown into the question outline / problem field. Re-run the script to
regenerate the files whenever the cartridge is re-exported.

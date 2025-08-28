# Scripts for using TEAMMATES (Peer Evaluation Software)

Note: Requires python v3.0 or higher.

## `reviewmultiplier.py`

To use, call:
`python3 reviewmultiplier.py <filepath to TEAMMATES .csv file>`

Given a .csv file exported by a team review session at https://teammatesv4.appspot.com, calculates multipliers proportional to the amount of work a teammate has done relative to the number of members in a team. Exports a folder with a question-by-question breakdown and a combined multiplier in multipliers.csv. By Tyler Lam (@TydaJL)
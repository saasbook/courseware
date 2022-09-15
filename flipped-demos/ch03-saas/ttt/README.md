# Another example: tic tac toe

Similar to the Sinatra Wordguesser CHIPS, this tiny app provides
another example of "RESTful thinking" and of bolting a Web UI onto
"UI-less" game logic.

The `TicTacToe` class exposes only a board configuration and whose
turn it is, and has simple methods to switch turns and to check if the
game is over.

The Sinatra app has just two routes, `GET /` to show the board and
`POST /move` that submits a one-element form to have the current
player make a move.

Fun enhancements to try:

1. Make the individual numbers in the squares clickable, so that each
player moves by clicking the number instead of typing into a form
field.  

2. Add a computer based opponent to play against. (A simple strategy
that actually isn't terrible is that if the player plays square `n`,
the computer can play square `(n-1) mod 8`)

3. Add a nicer UI.  Gosh, this one is terrible.

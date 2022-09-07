class TicTacToe

  class TicTacToe::IllegalMoveError < StandardError ; end

  attr_reader :board
  attr_reader :turn
  
  def initialize(first_player = 'x')
    # board is array: top row=0,1,2, middle=3,4,5, bottom=6,7,8
    # a square's value is either '' (empty), 'x', or 'o'
    @board = Array.new(9) { '' }
    # whose turn is it - 'x' or 'o'?
    @turn = first_player
  end

  def change_turn
    @turn = (@turn == 'x' ? 'o' : 'x')
  end

  def move(square)
    raise TicTacToe::IllegalMoveError unless
      square.between?(0,8) and @board[square].empty?
    @board[square] = @turn
    change_turn
  end

  def board_full?
    ! @board.any?(&:empty?)
  end

  def over?
    win?('x') or win?('o') or board_full?
  end

  def win?(player)
    win_patterns = [
      [0,1,2], [3,4,5], [6,7,8],
      [0,3,6], [1,4,7], [2,5,8],
      [0,4,8], [2,4,6]
    ]
    win_patterns.any? { |pat| pat.all? { |square| @board[square] == player }}
  end
end

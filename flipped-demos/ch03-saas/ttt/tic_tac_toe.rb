class TicTacToe

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

  def move(player,square)
    if @turn == player && square.between?(0,8) && @board[square].empty?
      @board[square] = player
      change_turn
    else
      nil
    end
  end

  def board_full
    # ! @board.any?(&:empty?)
    ! @board.any? { |square| square.empty? }
  end

  def over?
    wins?('x') or wins?('o') or board_full
  end

  def wins?(player)
    win_patterns = [
      [0,1,2], [3,4,5], [6,7,8],
      [0,3,6], [1,4,7], [2,5,8],
      [0,4,8], [2,4,6]
    ]
    win_patterns.any? { |pat| pat.all? { |square| @board[square] == player }}
  end

end

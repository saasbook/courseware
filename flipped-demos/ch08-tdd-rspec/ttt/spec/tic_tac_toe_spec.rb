require './tic_tac_toe.rb'
require 'byebug'

describe TicTacToe do
  before(:each) do
    @game = TicTacToe.new('o')
  end
  describe 'new game' do
    it 'starts with correct player' do
      expect(@game.turn).to eq 'o'
    end
    it 'raises IllegalMoveError if move to an occupied square' do
      @game.move(3)
      expect { @game.move(3) }.to raise_error(TicTacToe::IllegalMoveError)
    end
  end
  describe 'taking turns' do
    it 'changes to x if o just moved' do
      @game.move(1)
      expect(@game.turn).to eq('x')
    end
    it 'changes to o if x just moved' do
      @game.move(1)
      @game.move(2)
      expect(@game.turn).to eq('o')
    end
  end
  describe 'end of game' do
    context 'when no winner' do
      before(:each) do
        #  o x o
        #  o x o
        #  x o x
        (0..2).each { |square| @game.move(square) }
        (6..8).each { |square| @game.move(square) }
        (3..5).each { |square| @game.move(square) }
      end
      it 'indicates board full' do
        expect(@game.board_full?).to be_truthy
      end
      it 'indicates no win for x' do
        expect(@game).not_to be_a_win('x')
      end
      it 'indicates no win for o' do
        expect(@game).not_to be_a_win('o')
      end
    end
    
  end
end





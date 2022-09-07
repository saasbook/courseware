require './tic_tac_toe.rb'

describe TicTacToe do
  describe 'new game' do
    it 'starts with correct player' do
      game = TicTacToe.new('o')
      expect(game.turn).to eq 'o'
    end
    it 'disallows move to an occupied square' do
      game = TicTacToe.new('o')
      expect(game.move('o', 3)).to be_truthy
      expect(game.move('x', 3)).to be_falsy
    end
    it 'disallows move if not your turn' do
      game = TicTacToe.new('o')
      expect(game.move('x', 3)).to be_falsy
    end    
  end
end

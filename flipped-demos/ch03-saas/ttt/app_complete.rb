require 'sinatra'
require 'byebug'
require './tic_tac_toe.rb'

# Completed version of app.rb.  Run with:  rackup config_complete.ru
class TicTacToeApp < Sinatra::Base
  enable :sessions

  get '/' do
    session[:game] ||= TicTacToe.new('x')
    @game = session[:game]
    @message = session[:message]
    session[:message] = nil
    if @game.over?
      @winner = @game.winner
      @winner ? erb(:win_complete) : erb(:lose_complete)
    else
      erb :game_complete
    end
  end

  post '/move' do
    @game = session[:game] or raise RuntimeError.new("No game found!")
    square = params[:square].to_i
    if @game.move(@game.turn, square)
      session[:game] = @game
    else
      session[:message] = "Player #{@game.turn} cannot play square #{square}!"
    end
    redirect '/'
  end

  post '/new_game' do
    session[:game] = nil
    session[:message] = nil
    redirect '/'
  end
end

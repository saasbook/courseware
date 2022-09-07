require 'sinatra'
require 'byebug'
require './tic_tac_toe.rb'

class TicTacToeApp < Sinatra::Base
  enable :sessions

  # new game

  # make a move
  post '/move' do
    @game = session[:game] || raise("No game found!")
    square = params[:square].to_i
    @game.move(@game.turn,square)
    redirect '/'
  end
  # show the board

  get '/' do
    if session[:game]
      @game = session[:game]
    else
      @game = session[:game] = TicTacToe.new
    end
    if @game.over?
      erb :lose
    else
      erb :game
    end
  end
end

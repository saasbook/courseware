require 'sinatra'
require 'byebug'
require './tic_tac_toe.rb'

class TicTacToeApp < Sinatra::Base
  enable :sessions

  # if game already in progress, show board; else create a new game
  get '/' do
    session[:game] ||= TicTacToe.new('x') # if no existing game, start new one
    @game = session[:game]
    @message = session[:message] # in case there was any message to show
    session[:message] = nil      # ...it shouldn't persist after this request
    if @game.over?
      erb :lose
    else
      erb :game
    end
  end

  # make a move
  post '/move' do
    @game = session[:game] or raise RuntimeError.new("No game found!")
    square = params[:square].to_i
    if @game.move(@game.turn,square) # legal move
      session[:game] = @game
    else
      session[:message] = "Player #{@game.turn} cannot play square #{square}!"
    end
    # YOUR CODE HERE:  this is where you can check for @game.over? and
    # start over. (Hint: you can kill session[:game] and redirect to the
    # default action, possibly setting a message saying who if anyone wins)
    redirect '/'
  end

end

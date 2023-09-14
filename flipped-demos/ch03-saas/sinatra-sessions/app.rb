require 'sinatra'
require 'byebug'

class DemoApp < Sinatra::Base

  enable :sessions

  get '/hello/:something' do
    @content = params[:something]
    session[:thing] = @content
    erb :hello
  end

  get '/remember' do
    @remembered = session[:thing]
    erb :remember
  end
end

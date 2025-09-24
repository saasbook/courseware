require 'sinatra'
class DemoApp < Sinatra::Base
  # enable :sessions

  get '/' do
    # "hello cs169A!"
  end

  get '/set/:something' do
    puts params
    session[:thing] = params[:something]
    redirect '/'
  end
end

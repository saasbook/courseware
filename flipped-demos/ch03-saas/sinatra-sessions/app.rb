require 'sinatra'
class DemoApp < Sinatra::Base

  enable :sessions

  get '/' do
    @someone = session[:thing]
    erb :hello
  end

  get '/set/:something' do
    session[:thing] = params[:something]
    redirect '/'
  end

end

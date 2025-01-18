require 'sinatra'
class DemoApp < Sinatra::Base

  get '/' do
    "hello world!"
  end

  get '/set/:something' do
    session[:thing] = params[:something]
    redirect '/'
  end

end

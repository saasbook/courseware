require 'sinatra'

class DemoApp < Sinatra::Base

  get '/' do
    "It was #{@something}"
  end

  get '/i/love/:something' do
    @something = params[:something]
    erb :hello
  end

end

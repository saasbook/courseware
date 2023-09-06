require 'sinatra'

class DemoApp < Sinatra::Base

  get '/hello/:something' do
    @content = params[:something]
    erb :hello
  end
  
end

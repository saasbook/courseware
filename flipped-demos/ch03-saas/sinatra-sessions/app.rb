require 'sinatra'
class DemoApp < Sinatra::Base
  # enable :sessions

  get '/' do
    # "hello cs169A!"
    puts session
    @someone = session[:thing]
    # @data = ['CS169A', 'CS168', 'CS162']
    erb(:hello)
  end

  get '/set/:something' do
    puts params
    session[:thing] = params[:something]
    redirect '/'
  end
end

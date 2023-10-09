require 'sinatra'

class DemoApp < Sinatra::Base

  get '/' do
    "hello world!"
  end
  
end

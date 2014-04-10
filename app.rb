require 'sinatra'

class App < Sinatra::Application

  get '/' do
    erb :index
  end

  get '/resume' do
    erb :resume
  end

  get '/blog' do
    erb :blog
  end

  get '/portfolio' do
    erb :portfolio
  end

end
require './boot'

class App < Sinatra::Base
  set :sessions, true

  get '/ping' do
    'Hello world!'
  end
end

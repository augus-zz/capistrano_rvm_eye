require './boot'

class App < Sinatra::Application
  register Sinatra::Namespace

  use ActiveRecord::QueryCache
  use Rack::Parser, :parsers => {
    'application/json' => proc { |body| MultiJson.decode body },
  }

  helpers ::ErrorHelper

  before do
  end

  get '/ping' do
    'Hello world!'
  end

  namespace '/api' do
    include HomeController
  end

  namespace '/admin' do
    include Admin::HomeController
  end
end

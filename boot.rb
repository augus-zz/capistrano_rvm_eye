require "pathname"
APP_ROOT = Pathname.new(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.setup

Bundler.require(:default)

require 'dotenv'
Dotenv.load(
  APP_ROOT.join(".env.local"),
  APP_ROOT.join(".env")
)

ENV["RACK_ENV"] ||= "development"
Dotenv.load(
  APP_ROOT.join(".env.#{ENV['RACK_ENV']}")
)

env = ENV['RACK_ENV']
# RAILS_ENV work as well
if ENV["RAILS_ENV"]
  env = ENV["RAILS_ENV"]
end
ENV['RACK_ENV'] = env
RACK_ENV = env
puts "Boot from env: #{env}"

require 'json'
require "yaml"
require "erb"

require 'sinatra/namespace'
require 'sinatra/activerecord'

require 'multi_json'
require 'oj'
MultiJson.engine = :oj

config = YAML.load(ERB.new(File.read(File.join('config', 'database.yml'))).result)[RACK_ENV.to_s]
ActiveRecord::Base.establish_connection(config)

# time zone
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.time_zone_aware_attributes = true

$setting = YAML.load(ERB.new(File.read(File.join('config', 'setting.yml'))).result)

ENV["REDIS_HOST"] ||= "localhost"
ENV["REDIS_PORT"] ||= "6379"

ActiveSupport::Dependencies.autoload_paths << APP_ROOT.join("lib")
ActiveSupport::Dependencies.autoload_paths << APP_ROOT.join("app/controllers")
ActiveSupport::Dependencies.autoload_paths << APP_ROOT.join("app/models")
ActiveSupport::Dependencies.autoload_paths << APP_ROOT.join("lib/helpers")

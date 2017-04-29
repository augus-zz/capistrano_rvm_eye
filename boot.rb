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

require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'json'
require "yaml"
require "erb"

config = YAML.load(ERB.new(File.read(File.join('config', 'database.yml'))).result)[RACK_ENV.to_s]
ActiveRecord::Base.establish_connection(config)

# time zone
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.time_zone_aware_attributes = true

$setting = YAML.load(ERB.new(File.read(File.join('config', 'setting.yml'))).result)

ENV["REDIS_HOST"] ||= "localhost"
ENV["REDIS_PORT"] ||= "6379"

Dir["./lib/*.rb"].sort.each { |f| require f }


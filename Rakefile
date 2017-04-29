# Rakefile
require File.expand_path(File.dirname(__FILE__) + "/boot.rb")
require "sinatra/activerecord/rake"

namespace :db do
  desc 'Load the seed data from db/seeds.rb'
  task :seed do
    seed_file = "./db/seeds.rb"
    puts "Seeding database from: #{seed_file}"
    load(seed_file) if File.exist?(seed_file)
  end

  desc "rollback your migration"
  task :rollback do
    steps = ENV['STEPS']
    abort("no STEPS specified. use `rake db:rollback STEPS=1`") if !steps
    ActiveRecord::Migrator.rollback('db/migrate', steps.to_i)
  end

  desc 'Output the schema to db/schema.rb'
  task :schema => %w(env) do
    File.open('db/schema.rb', 'w:utf-8') do |f|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, f)
    end
  end
end

namespace :sidekiq do
  desc "start sidekiq"
  task :start do
    puts "start sidekiq cron"
    system("RACK_ENV=#{ENV['RACK_ENV']} bundle exec sidekiq -C #{APP_ROOT}/config/sidekiq-cron.yml -d")

    puts "start sidekiq"
    system("RACK_ENV=#{ENV['RACK_ENV']} bundle exec sidekiq -C #{APP_ROOT}/config/sidekiq.yml -d")
  end

  task :restart => [:stop, :start] do
  end

  task :stop do
    puts "stop sidekiq"
    system("bundle exec sidekiqctl stop #{APP_ROOT}/tmp/pids/sidekiq.pid")

    puts "stop sidekiq cron"
    system("bundle exec sidekiqctl stop #{APP_ROOT}/tmp/pids/sidekiq-cron.pid")
  end
end

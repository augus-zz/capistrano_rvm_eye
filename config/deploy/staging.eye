Eye.application 'KerryInfrasys' do
  working_dir '/opt/capistrano_rvm_eye/current'
  stdall 'log/eye.log'
  if File.exist?(File.join(working_dir, 'Gemfile'))
    clear_bundler_env
    env 'BUNDLE_GEMFILE' => File.join(working_dir, 'Gemfile')
  end
  env 'RAILS_ENV' => 'staging', 'RACK_ENV' => 'staging'

  group :sidekiq do
    {
      "worker" => "",
      "cron" => "-cron"
    }.each do |k, v|
      process k do
        pid_file "tmp/pids/sidekiq#{v}.pid"
        stdall "log/sidekiq#{v}.log"
        start_command "/bin/bash -l -c 'bundle exec sidekiq -C config/sidekiq#{v}.yml -e staging -d'"

        stop_signals [:USR1, 0, :TERM, 10.seconds, :KILL]
        start_timeout 120.seconds
        stop_timeout 30.seconds

        check :cpu, every: 30, below: 80, times: 5
        check :memory, every: 30, below: 200.megabytes, times: 5
      end
    end
  end

  process :ably do
    pid_file "tmp/pids/ably.pid"
    daemonize true
    stdall "log/ably.log"

    start_command "/bin/bash -l -c 'RACK_ENV=staging bundle exec ruby ably_app.rb'"
    stop_command 'kill -9 {PID}'

    start_timeout 100.seconds

    check :cpu, every: 30, below: 80, times: [3, 5]
    check :memory, every: 30, below: 100.megabytes, times: [3, 5]
  end

  process :puma do
    pid_file "tmp/pids/puma.pid"
    start_command "/bin/bash -l -c 'RACK_ENV=staging bundle exec puma -C config/puma.rb'"
    stop_signals [:TERM, 10.seconds]
    restart_command "kill -USR2 {PID}"

    start_timeout 100.seconds
    start_grace 10.seconds
    restart_grace 30.seconds

    check :cpu, every: 30, below: 80, times: 3
    check :memory, every: 30, below: 150.megabytes, times: [3, 5]
  end

end


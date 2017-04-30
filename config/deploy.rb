# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "CapistranoRvmEyeDemo"
set :repo_url, "git@github.com:zouqilin/capistrano_rvm_eye.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/opt/capistrano_rvm_eye"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :eye_command, 'eye'

namespace :deploy do
  after :updating, :copy_shared_config_files
  after :updated, :migrate

  after :finishing, :restart
  before :restart, :load_eye
end


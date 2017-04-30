namespace :deploy do
  desc 'copy shared config files'
  task :copy_shared_config_files do
    on roles(:all) do
      execute :cp, "#{shared_path}/.ruby-version #{release_path}/ | true"
      execute :cp, "#{shared_path}/.ruby-gemset #{release_path}/ | true"
      execute :cp, "#{shared_path}/.env #{release_path}/ | true"
      execute :cp, "#{shared_path}/.env.#{fetch(:rack_env)} #{release_path}/ | true"
      execute %{find #{release_path}/config -name *.example | awk '{print("cp "$1" "$1)}' | sed 's/.example//2' | bash }
    end
  end

  desc 'run DB migrations'
  task :migrate do
    on roles(:web) do
      within release_path do
        execute :rake, 'db:migrate'
      end
    end
  end

  desc "Start or reload eye config"
  task :load_eye do
    execute "#{fetch(:eye_command)} load #{current_path}/config/deploy/#{fetch(:rack_env)}.eye"
  end

  %w(start stop restart).each do |name|
    task name do
      on roles(:web) do
        execute "#{fetch(:eye_command)} #{name} CapistranoRvmEye"
      end

      on roles(:worker) do
        execute "#{fetch(:eye_command)} #{name} CapistranoRvmEye"
      end

      on roles(:cron) do
        execute "#{fetch(:eye_command)} #{name} CapistranoRvmEye"
      end

      on roles(:ably) do
        execute "#{fetch(:eye_command)} #{name} CapistranoRvmEye"
      end
    end
  end
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo 'systemctl reload-or-restart puma'
    end
  end

  desc 'Runs upgrade tasks before publishing'
  task :before_publishing do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'deploy:before_publishing'
        end
      end
    end
  end

  desc 'Runs upgrade tasks after finishing'
  task :after_finishing do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'deploy:after_finishing'
        end
      end
    end
  end
end

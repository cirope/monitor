namespace :deploy do
  desc 'Put records, remove and update the database using current app values'
  task :db_updates do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:update'
        end
      end
    end
  end
end

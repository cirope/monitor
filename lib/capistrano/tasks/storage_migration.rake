namespace :deploy do
  desc 'Migrate files from Carrierwave to ActiveStorage'
  task :storage_migration do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'storage:migrate'
        end
      end
    end
  end
end

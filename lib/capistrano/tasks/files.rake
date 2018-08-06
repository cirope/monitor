namespace :deploy do
  desc 'Move files form public/uploads to private'
  task :move_files do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          rake 'files:move'
        end
      end
    end
  end
end

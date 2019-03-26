namespace :deploy do
  desc 'Create default tenant and migrate current data to it'
  task :tenant do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          rake 'tenant:default'
        end
      end
    end
  end
end

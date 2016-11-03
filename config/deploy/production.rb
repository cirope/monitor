set :stage, :production
set :rails_env, 'production'
set :branch, 'new-init'

role :web, %w{deployer@monitor.cirope.com}
role :app, %w{deployer@monitor.cirope.com}
role :db,  %w{deployer@monitor.cirope.com}

server 'monitor.cirope.com', user: 'deployer', roles: %w{web app db}

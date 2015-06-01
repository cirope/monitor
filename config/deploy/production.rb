set :stage, :production
set :rails_env, 'production'

role :web, %w{deployer@monitor.com}
role :app, %w{deployer@monitor.com}
role :db,  %w{deployer@monitor.com}

server 'monitor.com', user: 'deployer', roles: %w{web app db}

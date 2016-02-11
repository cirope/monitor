set :rails_env, 'production'
set :branch, 'bsf'

role :web, %w{deployer@127.0.0.1}
role :app, %w{deployer@127.0.0.1}
role :db,  %w{deployer@127.0.0.1}

server '127.0.0.1', user: 'deployer', roles: %w{web app db}

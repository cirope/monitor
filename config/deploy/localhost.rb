# frozen_string_literal: true

set :rails_env, 'production'
set :branch, 'c-bica'

# set :default_env, {
#   'http_proxy': 'http://172.20.208.12:8080',
#   'https_proxy': 'http://172.20.208.12:8080'
# }

role :web, %w{deployer@127.0.0.1}
role :app, %w{deployer@127.0.0.1}
role :db,  %w{deployer@127.0.0.1}

server '127.0.0.1', user: 'deployer', roles: %w{web app db}

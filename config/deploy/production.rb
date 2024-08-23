# frozen_string_literal: true

set :stage, :production
set :rails_env, 'production'
set :branch, 'rails71'

role :web, %w{deployer@edge.greditsoft.com}
role :app, %w{deployer@edge.greditsoft.com}
role :db,  %w{deployer@edge.greditsoft.com}

server 'edge.greditsoft.com', user: 'deployer', roles: %w{web app db}

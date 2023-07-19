# frozen_string_literal: true

set :stage, :production
set :rails_env, 'production'
set :branch, 'base.greditsoft'

role :web, %w{deployer@base.greditsoft.com}
role :app, %w{deployer@base.greditsoft.com}
role :db,  %w{deployer@base.greditsoft.com}

server 'base.greditsoft.com', user: 'deployer', roles: %w{web app db}

# frozen_string_literal: true

set :stage, :production
set :rails_env, 'production'
set :branch, 'c-hullop'

role :web, %w{deployer@hullop.greditsoft.com}
role :app, %w{deployer@hullop.greditsoft.com}
role :db,  %w{deployer@hullop.greditsoft.com}

server 'hullop.greditsoft.com', user: 'deployer', roles: %w{web app db}

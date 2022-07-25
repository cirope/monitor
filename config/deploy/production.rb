# frozen_string_literal: true

set :stage, :production
set :rails_env, 'production'
set :branch, 'c-macro'

role :web, %w{deployer@macro.greditsoft.com}
role :app, %w{deployer@macro.greditsoft.com}
role :db,  %w{deployer@macro.greditsoft.com}

server 'macro.greditsoft.com', user: 'deployer', roles: %w{web app db}

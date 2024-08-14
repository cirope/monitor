# frozen_string_literal: true

set :stage, :production
set :rails_env, 'production'
set :branch, 'demo-new'

role :web, %w{deployer@demo-new.greditsoft.com}
role :app, %w{deployer@demo-new.greditsoft.com}
role :db,  %w{deployer@demo-new.greditsoft.com}

server 'demo-new.greditsoft.com', user: 'deployer', roles: %w{web app db}

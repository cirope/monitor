# frozen_string_literal: true

set :stage, :production
set :rails_env, 'production'
set :branch, 'c-arcos'

role :web, %w{deployer@arcos.greditsoft.com}
role :app, %w{deployer@arcos.greditsoft.com}
role :db,  %w{deployer@arcos.greditsoft.com}

server 'arcos.greditsoft.com', user: 'deployer', roles: %w{web app db}

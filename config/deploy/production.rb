# frozen_string_literal: true

set :stage, :production
set :rails_env, 'production'
set :branch, 'c-banco-del-chubut'

role :web, %w{deployer@banco-del-chubut.greditsoft.com}
role :app, %w{deployer@banco-del-chubut.greditsoft.com}
role :db,  %w{deployer@banco-del-chubut.greditsoft.com}

server 'banco-del-chubut.greditsoft.com', user: 'deployer', roles: %w{web app db}

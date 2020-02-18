source 'https://rubygems.org'

gem 'rails', '~> 5.2.4.1'

gem 'pg'
gem 'apartment'
gem 'sassc-rails'
gem 'bootstrap'
gem 'font-awesome-sass'
gem 'uglifier'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'activerecord-session_store'
gem 'net-ldap'
gem 'bcrypt'
gem 'responders'
gem 'simple_form'
gem 'figaro'
gem 'carrierwave'
gem 'validates_timeliness'
gem 'kaminari'
gem 'net-ssh'
gem 'net-scp'
gem 'request_store'
gem 'request_store-sidekiq'
gem 'sidekiq'
gem 'apartment-sidekiq'
gem 'whenever', require: false
gem 'paper_trail'
gem 'roadie-rails'
gem 'ruby-ntlm'
gem 'rubyzip', require: 'zip'
gem 'diffy'
gem 'prawn'
gem 'prawn-table'
gem 'coderay'

gem 'web-console'

gem 'unicorn'
gem 'unicorn-rails'

gem 'newrelic_rpm', '~> 6.2.0'

gem 'capistrano'
gem 'capistrano-rbenv'
gem 'capistrano-bundler'
gem 'capistrano-rails'

group :development do
  gem 'listen'
  gem 'rubocop-github'

  # Support for ed25519 ssh keys
  gem 'ed25519'
  gem 'bcrypt_pbkdf'
end

group :development, :test do
  gem 'byebug'
end

group :test do
  gem 'timecop'
end

# Separate script gem dependencies from application dependencies
extra_gemfile = File.join File.dirname(__FILE__), 'Gemfile.local'

instance_eval File.read(extra_gemfile) if File.readable? extra_gemfile

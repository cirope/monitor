source 'https://rubygems.org'

gem 'rails', '~> 5.1.4'

gem 'pg'
gem 'sass-rails'
gem 'bootstrap-sass'
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
gem 'jc-validates_timeliness'
gem 'kaminari'
gem 'net-ssh'
gem 'net-scp'
gem 'request_store'
gem 'sidekiq'
gem 'whenever', require: false
gem 'paper_trail'
gem 'roadie-rails'
gem 'ruby-ntlm'
gem 'rubyzip', require: 'zip'
gem 'diffy'
gem 'prawn'
gem 'prawn-table'
gem 'coderay'

gem 'unicorn'

gem 'newrelic_rpm'

gem 'capistrano'
gem 'capistrano-rbenv'
gem 'capistrano-bundler'
gem 'capistrano-rails'
gem 'capistrano-sidekiq'


group :development do
  gem 'unicorn-rails'
  gem 'web-console'
  gem 'listen'

  # Support for ed25519 ssh keys
  gem 'rbnacl', '< 5.0' # TODO: check net-ssh dependency to _unleash_
  gem 'bcrypt_pbkdf'
end

group :development, :test do
  gem 'byebug'
end

group :test do
  gem 'timecop'
end

# Some user script dependencies
gem 'composite_primary_keys', require: false
gem 'ruby-odbc', require: false

source 'https://rubygems.org'

gem 'rails', '~> 7.0'

gem 'pg', '< 1.5'
gem 'ros-apartment', require: 'apartment'
gem 'sassc-rails'
gem 'bootstrap', '< 5.3'
gem 'font-awesome-sass'
gem 'importmap-rails'
gem 'terser'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbo-rails'
gem 'jbuilder'
gem 'activerecord-session_store'
gem 'net-ldap'
gem 'bcrypt'
gem 'simple_form'
gem 'figaro'
gem 'validates_timeliness', '~> 7.0.0.beta1'
gem 'kaminari'
gem 'net-ssh'
gem 'net-scp'
gem 'request_store'
gem 'request_store-sidekiq'
gem 'sidekiq', '< 7'
gem 'ros-apartment-sidekiq', require: 'apartment-sidekiq'
gem 'whenever', require: false
gem 'paper_trail'
gem 'premailer-rails'
gem 'ruby-ntlm'
gem 'rubyzip', require: 'zip'
gem 'diffy'
gem 'prawn'
gem 'prawn-table'
gem 'coderay'
gem 'mimemagic'
gem 'jwt'
gem 'simple_command'
gem 'matrix'
gem 'net-smtp', '< 0.4', require: false
gem 'net-pop', require: false
gem 'net-imap', require: false
gem 'ruby-saml'
gem 'oauth2'
gem 'wicked_pdf'
gem 'ruby-odbc', github: 'vhermecz/ruby-odbc'

group :development, :production do
  gem 'web-console'
end

gem 'unicorn'
gem 'unicorn-rails'

gem 'capistrano'
gem 'capistrano-rbenv'
gem 'capistrano-bundler'
gem 'capistrano-rails'

group :development do
  gem 'listen'
  gem 'minitest-reporters'

  # Support for ed25519 ssh keys
  gem 'ed25519'
  gem 'bcrypt_pbkdf'
  gem 'brakeman'
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

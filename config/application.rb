# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MonitorApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib ignore: %w(assets capistrano tasks templates)

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.eager_load_paths << Rails.root.join("extras")

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake time:zones:all" for a time zone names list. Default is UTC.
    config.time_zone = 'Buenos Aires'

    # Be sure to have the adapter's gem in your Gemfile
    # and follow the adapter's specific installation
    # and deployment instructions.
    config.active_job.queue_adapter = :sidekiq

    unless Rails.env.test?
      # Global web console configuration
      config.web_console.development_only = false
      config.web_console.mount_point      = "/console/#{SecureRandom.uuid}"
      config.web_console.permissions      = '0.0.0.0/0'
    end

    # Permitted hosts
    config.hosts << ENV['APP_HOST']
  end
end

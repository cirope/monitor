module Endpoints::DynamicsOptions
  extend ActiveSupport::Concern

  PROVIDER_OPTIONS = {
    dynamics: {
      client_id:     { type: :string, required: true },
      client_secret: { type: :string, required: true },
      directory_id:  { type: :string, required: true }
    }
  }

  def provider_options
    PROVIDER_OPTIONS[provider.to_sym]
  end

  module ClassMethods
    def provider_options provider
      Endpoint::PROVIDER_OPTIONS[provider.to_sym]
    end

    def required_options provider
      provider_options(provider).select { |k,v| v[:required] }.keys
    end
  end

  def client_id
    options&.fetch 'client_id', nil
  end

  def client_id= client_id
    assign_option 'client_id', client_id
  end

  def client_secret
    options&.fetch 'client_secret', nil
  end

  def client_secret= client_secret
    assign_option 'client_secret', client_secret
  end

  def directory_id
    options&.fetch 'directory_id', nil
  end

  def directory_id= directory_id
    assign_option 'directory_id', directory_id
  end

  private

    def assign_option name, value
      self.options ||= {}
      prev_value     = self.options[name]

      options_will_change! unless prev_value == value

      self.options[name] = value
    end
end

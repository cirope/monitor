module Drives::Providers
  extend ActiveSupport::Concern

  include Rails.application.routes.url_helpers

  PROVIDERS = ['drive', 'onedrive', 'sharepoint']

  PROVIDERS.each do |provider|
    define_method "#{provider}?" do
      self.provider == provider
    end
  end

  def provider_client
    send "#{provider}_client"
  end

  def provider_auth_url
    send "#{provider}_auth_url"
  end

  def redirect_uri
    url_for(
      controller: 'drives/providers', action: 'index', host: ENV['APP_HOST']
    )
  end
end

module Drives::Providers
  extend ActiveSupport::Concern

  def provider_client
    send "#{provider}_client"
  end

  def provider_auth_url
    send "#{provider}_auth_url"
  end

  def provider_config code
    send "#{provider}_config", code
  end
end

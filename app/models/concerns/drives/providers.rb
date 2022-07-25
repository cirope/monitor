module Drives::Providers
  extend ActiveSupport::Concern

  def provider_client
    send "#{provider}_client"
  end

  def provider_auth_url
    send "#{provider}_auth_url"
  end

  def redirect_to_auth_url?
    saved_change_to_provider?  ||
    saved_change_to_client_id? ||
    saved_change_to_client_secret?
  end
end

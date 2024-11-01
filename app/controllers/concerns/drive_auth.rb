module DriveAuth
  extend ActiveSupport::Concern

  included do
    helper_method :provider_auth_url
  end

  def provider_auth_url drive
    uri = URI.parse drive.provider_auth_url

    uri.to_s
  end
end

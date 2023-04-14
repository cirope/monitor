module Drives::OneDrive
  extend ActiveSupport::Concern

  def onedrive_client
    OAuth2::Client.new(
      client_id, client_secret,
      site:          "https://login.microsoftonline.com/",
      token_url:     "/#{tenant_id}/oauth2/v2.0/token",
      authorize_url: "/#{tenant_id}/oauth2/v2.0/authorize"
    )
  end

  def onedrive_auth_url
    onedrive_client.auth_code.authorize_url(
      redirect_uri: redirect_uri,
      scope:        'files.read files.read.all files.readwrite files.readwrite.all offline_access',
      state:        identifier
    )
  end

  def onedrive_config code
    auth_token = onedrive_token_url(code)

    {
      access_token:  auth_token.token,
      refresh_token: auth_token.refresh_token,
      token_type:    auth_token.response.parsed['token_type'],
      expiry:        Time.zone.at(auth_token.expires_at)
    }.to_json if auth_token.response&.status.to_i == 200
  end

  private

    def onedrive_token_url code
      onedrive_client.auth_code.get_token(
        code,
        redirect_uri: redirect_uri
      )
    end
end

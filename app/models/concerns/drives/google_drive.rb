module Drives::GoogleDrive
  extend ActiveSupport::Concern

  include Rails.application.routes.url_helpers

  def drive_client
    OAuth2::Client.new(
      client_id, client_secret,
      site:          'https://accounts.google.com',
      token_url:     '/o/oauth2/token',
      authorize_url: '/o/oauth2/auth'
    )
  end

  def drive_auth_url
    drive_client.auth_code.authorize_url(
      redirect_uri: redirect_uri,
      scope:        'https://www.googleapis.com/auth/drive',
      state:        identifier
    )
  end

  def drive_config code
    auth_token = drive_token_url(code)

    if auth_token.response&.status.to_i == 200
      token_json = {
        access_token:  auth_token.token,
        refresh_token: auth_token.refresh_token,
        token_type:    auth_token.response.parsed['token_type'],
        expiry:        Time.zone.at(auth_token.expires_at)
      }.to_json

      system config_file(token_json)
    end
  end

  private

    def redirect_uri
      url_for(
        controller: 'drives/providers', action: 'index', host: ENV['APP_HOST']
      )
    end

    def drive_token_url code
      drive_client.auth_code.get_token(
        code,
        redirect_uri: redirect_uri
      )
    end

    def config_file token_json
      [
        'rclone config create',
        "#{section}",
        "#{provider}",
        'config_is_local false',
        "client_id #{client_id}",
        "client_secret #{client_secret}",
        "token '#{token_json}'"
      ].join ' '
    end
end

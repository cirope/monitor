# frozen_string_literal: true

Rails.application.configure do
  config.action_mailer.default_url_options = {
    host: ENV['APP_HOST'], protocol: ENV['APP_PROTOCOL']
  }
  config.action_mailer.default_url_options[:port] = 3000 if Rails.env.development?

  config.action_mailer.smtp_settings = {
    address:              ENV['SMTP_ADDRESS'],
    port:                 ENV['SMTP_PORT'],
    domain:               ENV['SMTP_DOMAIN'],
    user_name:            ENV['SMTP_USER_NAME'],
    password:             ENV['SMTP_PASSWORD'],
    authentication:       ENV['SMTP_AUTHENTICATION'].present? ? ENV['SMTP_AUTHENTICATION'] : nil,
    enable_starttls_auto: ENV['SMTP_ENABLE_STARTTLS_AUTO'] == 'true',
    openssl_verify_mode:  OpenSSL::SSL::VERIFY_NONE
  }
end

# frozen_string_literal: true

class JsonWebToken
  class << self
    def encode payload
      payload[:exp] = (payload[:exp] || 24.hours.from_now).to_i

      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]

      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end

# frozen_string_literal: true

class Api::V1::AuthorizeApiRequest
  prepend SimpleCommand

  def initialize headers = {}
    @headers = headers
  end

  def call
    user
  end

  private

    attr_reader :headers

    def user
      if decoded_auth_token && Account.exists?(decoded_auth_token[:account_id])
        Current.account = Account.find decoded_auth_token[:account_id]

        Current.account.switch!

        return User.find decoded_auth_token[:user_id] if User.exists? decoded_auth_token[:user_id]
      end

      errors.add(:token, I18n.t('api.v1.authorize_api_request.errors.invalid_token')) && nil
    end

    def decoded_auth_token
      @decoded_auth_token ||= JsonWebToken.decode http_auth_header
    end

    def http_auth_header
      if headers['Authorization'].present?
        return headers['Authorization'].split.last
      else
        errors.add(:token, I18n.t('api.v1.authorize_api_request.errors.missing_token'))
      end

      nil
    end
end

# frozen_string_literal: true

class Api::V1::AuthenticateUser
  prepend SimpleCommand

  def initialize user, account
    @user    = user
    @account = account
    @exp     = account.expire_token
  end

  def call
    if @user && @account
      JsonWebToken.encode user_id: @user.id, account_id: @account.id, exp: @exp
    else
      errors.add(:token, I18n.t('api.v1.authenticate_user.not_generate_token')) && nil
    end
  end
end

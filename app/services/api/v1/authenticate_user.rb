# frozen_string_literal: true

class Api::V1::AuthenticateUser
  prepend SimpleCommand

  def initialize(user, account)
    @user    = user
    @account = account
  end

  def call
    if @user && @account
      JsonWebToken.encode({ user_id: @user.id, account_id: @account.id })
    else
      errors.add :token, 'No se puede generar el token'
      nil
    end
  end
end

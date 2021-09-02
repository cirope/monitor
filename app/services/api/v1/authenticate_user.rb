# frozen_string_literal: true

class Api::V1::AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(username: user.username) if user
  end

  private

    attr_accessor :email, :password
  
    def user
      user = User.find_by_email(email)
      return user if user && user.authenticate(password)
    
      errors.add :user_authentication, 'invalid credentials'
      nil
    end
end

# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def password_reset user
    @user = user

    mail to: user.email
  end
end

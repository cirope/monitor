# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.new email: 'test@test.com',
                    name: 'test name',
                    password_reset_token: SecureRandom.urlsafe_base64

    Account.first.switch!

    UserMailer.password_reset user
  end
end

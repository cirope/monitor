# frozen_string_literal: true

module Users::PasswordReset
  extend ActiveSupport::Concern

  included do
    has_secure_token :password_reset_token
  end

  def prepare_password_reset
    self.password_reset_sent_at = Time.zone.now

    regenerate_password_reset_token
    save!
  end

  def password_expired?
    password_reset_sent_at < 2.hours.ago
  end
end

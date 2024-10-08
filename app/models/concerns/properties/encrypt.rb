module Properties::Encrypt
  extend ActiveSupport::Concern

  included do
    before_save :encrypt_password, if: :password?
  end

  def password
    ::Security.decrypt value if value.present?
  rescue => ex
    Rails.logger.error ex

    value
  end

  private

    def encrypt_password
      self.value = ::Security.encrypt(value) if value.present?
    end
end

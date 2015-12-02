module Users::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password

    before_create { generate_token :auth_token }
  end

  def auth password
    ldap = Ldap.default

    if ldap
      password.present? && ldap.ldap(username, password).bind
    else
      authenticate password
    end
  end

  private

  def generate_token column
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end

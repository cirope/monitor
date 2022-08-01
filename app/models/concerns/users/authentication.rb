# frozen_string_literal: true

module Users::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
    has_secure_token :auth_token
  end

  def update_saml_request_id new_request_id
    update_column :saml_request_id, new_request_id
  end

  def auth password
    ldap = Ldap.default

    if ldap
      password.present? && ldap.ldap(username, password).bind
    else
      authenticate password
    end
  end
end

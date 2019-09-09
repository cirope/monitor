# frozen_string_literal: true

module Ldaps::Auth
  extend ActiveSupport::Concern

  def ldap username, password
    Net::LDAP.new host: hostname, port: port, auth: {
      method:   :simple,
      username: login_mask % { user: username, basedn: basedn },
      password: password
    }
  end
end

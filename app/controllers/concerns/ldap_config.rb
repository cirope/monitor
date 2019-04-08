# frozen_string_literal: true

module LdapConfig
  extend ActiveSupport::Concern

  included do
    helper_method :ldap
  end

  def ldap
    @ldap ||= Ldap.default
  end
end

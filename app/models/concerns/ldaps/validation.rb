module Ldaps::Validation
  extend ActiveSupport::Concern

  included do
    attr_accessor :test_user, :test_password

    validates :test_user, :test_password, :hostname, :port, :basedn, :filter,
      :login_mask, :username_attribute, :name_attribute,
      :lastname_attribute, :email_attribute, presence: true
    validates :hostname, :basedn, :filter, :login_mask, :username_attribute,
      :name_attribute, :lastname_attribute, :email_attribute,
      length: { maximum: 255 }
    validates :port, numericality: { only_integer: true, greater_than: 0, less_than: 65536 }
    validates :basedn, format: /\A(\w+=[\w-]+)(,\w+=[\w-]+)*\z/
    validates :username_attribute, :name_attribute, :lastname_attribute,
      :email_attribute, format: /\A\w+\z/, allow_blank: true
    validate :can_connect?
  end

  private

    def can_connect?
      ldap = ldap test_user, test_password

      errors.add :base, I18n.t('messages.ldap_error') unless ldap.bind
    rescue
      errors.add :base, I18n.t('messages.ldap_error')
    end
end

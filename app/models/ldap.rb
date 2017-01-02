class Ldap < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Ldaps::Import
  include Ldaps::Auth
  include Ldaps::Options
  include Ldaps::Validation

  strip_fields :hostname, :basedn, :filter, :login_mask, :username_attribute,
    :name_attribute, :lastname_attribute, :email_attribute

  def self.default
    order(:id).first
  end

  def to_s
    hostname
  end
end

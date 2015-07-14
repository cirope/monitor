class Ldap < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include Ldaps::Import
  include Ldaps::Auth
  include Ldaps::Validation

  strip_fields :hostname, :basedn, :filter, :login_mask, :username_attribute,
    :name_attribute, :lastname_attribute, :email_attribute

  def to_s
    hostname
  end
end

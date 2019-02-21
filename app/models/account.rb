class Account < ApplicationRecord
  include Attributes::Strip
  include Attributes::Downcase
  include Accounts::Memberships
  include Accounts::Request
  include Accounts::Tenant
  include Accounts::Validation
  include PublicAuditable

  strip_fields :name, :tenant_name
  downcase_fields :tenant_name

  attr_readonly :tenant_name

  has_many :databases, dependent: :destroy

  def to_s
    name
  end

  def to_param
    tenant_name
  end
end

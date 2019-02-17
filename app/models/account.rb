class Account < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Attributes::Downcase
  include Accounts::Memberships
  include Accounts::Request
  include Accounts::Tenant
  include Accounts::Validation

  strip_fields :name, :tenant_name
  downcase_fields :tenant_name

  attr_readonly :tenant_name
end

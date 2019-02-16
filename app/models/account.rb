class Account < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Attributes::Downcase
  include Accounts::Request
  include Accounts::Tenant
  include Accounts::Validation

  attr_readonly :tenant_name

  strip_fields :name, :tenant_name
  downcase_fields :tenant_name
end

class Account < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Attributes::Downcase
  include Accounts::Validation

  strip_fields :name, :tenant_name
  downcase_fields :tenant_name
end

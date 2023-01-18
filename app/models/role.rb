class Role < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Roles::Overrides
  include Roles::Relations
  include Roles::Scopes
  include Roles::Validation

  strip_fields :name, :description
end

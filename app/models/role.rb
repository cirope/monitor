class Role < ApplicationRecord
  include Auditable
  include DisableSti
  include Attributes::Strip
  include Roles::Identifer
  include Roles::Overrides
  include Roles::Relations
  include Roles::Scopes
  include Roles::Types
  include Roles::Validation

  strip_fields :name, :description, :identity
end

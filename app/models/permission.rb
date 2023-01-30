class Permission < ApplicationRecord
  include Permissions::Relations
  include Permissions::Sections
  include Permissions::Scopes
  include Permissions::Validation
end

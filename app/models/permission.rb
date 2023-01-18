class Permission < ApplicationRecord
  include Permissions::Relations
  include Permissions::Scopes
  include Permissions::Validation
end

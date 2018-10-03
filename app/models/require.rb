class Require < ApplicationRecord
  include Auditable
  include Requires::Scopes
  include Requires::Validation

  belongs_to :caller, class_name: 'Script', optional: true
  belongs_to :script
end

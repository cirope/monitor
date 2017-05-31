class Require < ApplicationRecord
  include Auditable
  include Requires::Scopes

  validates :script, presence: true

  belongs_to :caller, class_name: 'Script', optional: true
  belongs_to :script
end

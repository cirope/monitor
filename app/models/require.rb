class Require < ActiveRecord::Base
  include Auditable
  include Requires::Scopes

  validates :script, presence: true

  belongs_to :caller, class_name: 'Script'
  belongs_to :script
end

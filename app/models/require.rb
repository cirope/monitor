class Require < ActiveRecord::Base
  include Auditable

  validates :script, presence: true

  belongs_to :caller, class_name: 'Script'
  belongs_to :script
end

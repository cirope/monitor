class Dependency < ApplicationRecord
  include Auditable

  validates :schedule, presence: true

  belongs_to :dependent, class_name: 'Schedule'
  belongs_to :schedule
end

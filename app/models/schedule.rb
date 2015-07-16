class Schedule < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Schedules::Runs
  include Schedules::Validation

  scope :ordered, -> { order :start, :end, :id }

  strip_fields :name

  belongs_to :script
  belongs_to :server

  def to_s
    name
  end
end

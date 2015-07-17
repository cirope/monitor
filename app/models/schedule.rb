class Schedule < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Schedules::Dependencies
  include Schedules::Runs
  include Schedules::Validation

  scope :ordered, -> { order end: :desc, start: :asc, id: :asc }

  strip_fields :name

  belongs_to :script
  belongs_to :server

  def to_s
    name
  end
end

class Schedule < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Schedules::Dependencies
  include Schedules::Jobs
  include Schedules::Runs
  include Schedules::Scheduler
  include Schedules::Validation
  include Taggable

  scope :ordered, -> { order end: :desc, start: :asc, id: :asc }

  strip_fields :name

  def to_s
    name
  end
end

class Schedule < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Schedules::Cleanup
  include Schedules::Dependencies
  include Schedules::Destroy
  include Schedules::Dispatchers
  include Schedules::Jobs
  include Schedules::Runs
  include Schedules::Scheduler
  include Schedules::Validation
  include Taggable

  scope :ordered, -> { order end: :desc, start: :asc, id: :asc }
  scope :visible, -> { where hidden: false }

  strip_fields :name

  def to_s
    name
  end
end

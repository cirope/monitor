class Schedule < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include Schedules::Runs
  include Schedules::Validation

  strip_fields :name

  belongs_to :script
  belongs_to :server

  def to_s
    name
  end
end

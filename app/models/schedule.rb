# frozen_string_literal: true

class Schedule < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Filterable
  include SearchableByName
  include Schedules::Cleanup
  include Schedules::Dependencies
  include Schedules::Destroy
  include Schedules::Dispatchers
  include Schedules::Jobs
  include Schedules::Runs
  include Schedules::Scheduler
  include Schedules::Scopes
  include Schedules::Validation

  strip_fields :name

  def to_s
    name
  end
end

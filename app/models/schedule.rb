class Schedule < ActiveRecord::Base
  include Schedules::Runs
  include Schedules::Validation

  belongs_to :script
  belongs_to :server

  def to_s
    [script, server].join(' -> ')
  end
end

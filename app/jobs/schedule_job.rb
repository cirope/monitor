class ScheduleJob < ActiveJob::Base
  queue_as :default

  def perform schedule
    schedule.build_next_runs
  end
end

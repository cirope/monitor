class ScheduleCleanupJob < ActiveJob::Base
  queue_as :default

  def perform schedule
    schedule.cleanup
  end
end

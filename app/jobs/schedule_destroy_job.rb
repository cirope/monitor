class ScheduleDestroyJob < ActiveJob::Base
  queue_as :default

  def perform schedule
    schedule.destroy
  end
end

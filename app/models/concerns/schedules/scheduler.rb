module Schedules::Scheduler
  extend ActiveSupport::Concern

  included do
    scope :next_to_schedule, -> {
      interval = "CAST(#{table_name}.interval || ' ' || #{table_name}.frequency AS Interval)"

      where "#{table_name}.scheduled_at + #{interval} <= ?", Time.zone.now
    }
  end

  module ClassMethods
    def schedule
      next_to_schedule.find_each do |schedule|
        scheduled_at = schedule.next_date

        schedule.update! scheduled_at: scheduled_at

        ScheduleJob.set(wait_until: scheduled_at).perform_later schedule
      end
    end
  end
end

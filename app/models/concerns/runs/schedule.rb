module Runs::Schedule
  extend ActiveSupport::Concern

  included do
    scope :pending,          -> { where status: 'pending' }
    scope :next_to_schedule, -> {
      pending.where "#{table_name}.scheduled_at <= ?", 2.minutes.from_now
    }
  end

  module ClassMethods
    def schedule
      next_to_schedule.find_each do |run|
        run.update! status: 'scheduled'

        ScriptJob.set(wait_until: run.scheduled_at).perform_later run
      end
    end
  end
end

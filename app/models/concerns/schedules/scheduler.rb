# frozen_string_literal: true

module Schedules::Scheduler
  extend ActiveSupport::Concern

  included do
    scope :next_to_schedule, -> {
      where "#{table_name}.scheduled_at < ?", Time.zone.now
    }
  end

  module ClassMethods
    def schedule
      Account.on_each do
        schedule_all
      end
    end

    private

      def schedule_all
        visible.next_to_schedule.find_each do |schedule|
          scheduled_at = schedule.next_date

          schedule.update! scheduled_at: scheduled_at

          schedule.cancel_pending_runs
          schedule.build_next_runs
        end
      end
  end
end

# frozen_string_literal: true

module Reminders::Execution
  extend ActiveSupport::Concern

  module ClassMethods
    def schedule
      Account.on_each do
        schedule_all
      end
    end

    private

      def schedule_all
        next_to_schedule.find_each do |reminder|
          reminder.scheduled

          ReminderJob.set(wait_until: reminder.due_at).perform_later reminder
        end
      end
  end
end

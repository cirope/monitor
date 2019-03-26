# frozen_string_literal: true

class ScheduleCleanupJob < ApplicationJob
  queue_as :default

  def perform schedule
    schedule.cleanup
  end
end

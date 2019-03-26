# frozen_string_literal: true

class ScheduleDestroyJob < ApplicationJob
  queue_as :default

  def perform schedule
    schedule.destroy
  end
end

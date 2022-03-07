# frozen_string_literal: true

class ReminderJob < ApplicationJob
  queue_as :default

  def perform reminder
    reminder.notify
  end
end

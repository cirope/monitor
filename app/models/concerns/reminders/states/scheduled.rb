# frozen_string_literal: true

class Reminders::States::Scheduled < Reminders::States::State
  def initialize; end;

  def notify reminder
    ReminderMailer.reminder_issue(reminder).deliver_later

    reminder.update state_class_type: 'Done'
  end
end

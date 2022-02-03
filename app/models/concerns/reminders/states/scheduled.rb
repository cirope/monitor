# frozen_string_literal: true

class Reminders::States::Scheduled < Reminders::States::State
  def initialize; end;

  def notify reminder
    reminder.issue.users.each do |user|
      ReminderMailer.reminder_issue(reminder, user).deliver_later
    end

    reminder.update state_class_type: 'Done'
  end
end

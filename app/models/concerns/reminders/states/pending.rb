# frozen_string_literal: true

class Reminders::States::Pending < Reminders::States::State
  def initialize; end;

  def notify reminder
    # send email or notification
    reminder.update state_class_type: 'Done'
  end
end

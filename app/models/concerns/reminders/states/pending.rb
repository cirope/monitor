# frozen_string_literal: true

class Reminders::States::Pending < Reminders::States::State
  def initialize; end;

  def notify reminder
    # do nothing
  end
end

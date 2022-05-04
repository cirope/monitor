# frozen_string_literal: true

class Reminders::States::Canceled < Reminders::States::State
  def initialize; end;

  def notify reminder
    # do nothing
  end
end

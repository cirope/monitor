# frozen_string_literal: true

class Reminders::States::State
  def initialize
    raise 'Cannot initialize an abstract State class'
  end

  def notify reminder
    raise NotImplementedError
  end
end

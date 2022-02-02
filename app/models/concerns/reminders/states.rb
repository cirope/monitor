# frozen_string_literal: true

module Reminders::States
  extend ActiveSupport::Concern

  STATUSES = %w(Pending Scheduled Canceled Done)

  included do
    before_validation :set_default_state_class_type
  end

  def state
    "Reminders::States::#{state_class_type.capitalize}".constantize.new
  end

  def scheduled
    self.update state_class_type: 'Scheduled'
  end

  private

    def set_default_state_class_type
      self.state_class_type ||= 'Pending'
    end
end

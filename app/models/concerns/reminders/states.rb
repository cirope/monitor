# frozen_string_literal: true

module Reminders::States
  extend ActiveSupport::Concern

  STATUSES = %w(Pending Canceled Done)

  included do
    before_validation :set_default_state_class_type
  end

  def state
    "Reminders::States::#{state_class_type}".constantize.new
  end

  private

    def states
      STATUSES
    end

    def set_default_state_class_type
      self.state_class_type ||= 'Pending'
    end
end

# frozen_string_literal: true

module Reminders::Validation
  extend ActiveSupport::Concern

  included do
    validates :state_class_type, presence: true, inclusion: { in: Reminders::States::STATUSES }
    validates :due_at, presence: true
    validate :valid_due_at, if: -> { due_at.present? }
  end

  private

    def valid_due_at
      if due_at < (Time.now + 5.minutes)
        errors.add(:due_at, :invalid)
      end
    end
end

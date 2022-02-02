# frozen_string_literal: true

module Reminders::Scopes
  extend ActiveSupport::Concern

  included do
    scope :pending, -> { where state_class_type: 'Pending' }
    scope :next_to_schedule, -> {
      pending.where "#{table_name}.due_at <= ?", 10.minutes.from_now
    }
  end
end

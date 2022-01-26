# frozen_string_literal: true

module Reminders::Validation
  extend ActiveSupport::Concern

  included do
    validates :state_class_type, presence: true, inclusion: { in: Reminders::States::STATUSES }
  end
end

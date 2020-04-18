# frozen_string_literal: true

module Panels::Validation
  extend ActiveSupport::Concern

  PERIODS      = %w(total day week month year)
  FREQUENCIES  = %w(hourly daily weekly monthly yearly)
  FUNCTIONS    = %w(count minimum maximum sum average)
  OUTPUT_TYPES = %w(bar pie line)

  included do
    validates :title, :height, :width, :function, :output_type, presence: true
    validates :title,
      length:     { maximum: 255 },
      uniqueness: { case_sensitive: false, scope: :dashboard_id }
    validates :width, :height, numericality: {
      only_integer: true, greater_than: 0, less_than: 4
    }
    validates :function,
      inclusion: { in: Panel::FUNCTIONS }
    validates :output_type,
      inclusion: { in: Panel::OUTPUT_TYPES }
    validates :period,
      inclusion: { in: Panel::PERIODS }

    with_options if: :range do |options|
      options.validates :start_count, :finish_count,
        presence: true,
        numericality: {
          only_integer: true, greater_than_or_equal_to: 0
        }
      options.validates :from_period, :to_period,
        inclusion: { in: Panel::PERIODS }
      options.validates :frequency,
        inclusion: { in: Panel::FREQUENCIES }
    end
  end
end

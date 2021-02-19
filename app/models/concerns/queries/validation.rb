# frozen_string_literal: true

module Queries::Validation
  extend ActiveSupport::Concern

  FREQUENCIES = %w(hourly daily weekly monthly yearly)
  FUNCTIONS   = %w(count minimum maximum sum average)
  PERIODS     = %w(total day week month year)
  OUTPUTS     = %w(column pie line area donut)

  included do
    validates :output, :function, :period, :filters, presence: true
    validates :function,
      inclusion: { in: Query::FUNCTIONS }
    validates :period,
      inclusion: { in: Query::PERIODS }
    validates :output,
      inclusion: { in: Query::OUTPUTS }
    #validates_datetime :from_at
    #validates_datetime :to_at, after: :from_at

    with_options if: :range do |options|
      options.validates :from_count, :to_count,
        presence: true,
        numericality: {
          only_integer: true, greater_than_or_equal_to: 0
        }
      options.validates :from_period, :to_period,
        inclusion: { in: Query::PERIODS }
      options.validates :frequency,
        inclusion: { in: Query::FREQUENCIES }
    end
  end
end

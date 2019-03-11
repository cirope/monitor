# frozen_string_literal: true

module Schedules::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, length: { maximum: 255 }
    validates :start, presence: true, timeliness: { type: :datetime }
    validates :start, timeliness: { type: :datetime, on_or_after: :now }, if: :start_changed?
    validates :end, timeliness: { type: :datetime, after: :start }, allow_blank: true
    validates :interval, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true
    validates :frequency, inclusion: { in: %w(minutes hours days weeks months) }, allow_blank: true
  end
end

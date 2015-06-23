module Schedules::Validation
  extend ActiveSupport::Concern

  included do
    validates :script, :server, presence: true
    validates :start, presence: true, timeliness: { type: :datetime, on_or_after: :now }
    validates :end, timeliness: { type: :datetime, after: :start }, allow_blank: true
    validates :interval, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true
    validates :frequency, inclusion: { in: %w(minutes hourly daily weekly monthly) }, allow_blank: true
  end
end

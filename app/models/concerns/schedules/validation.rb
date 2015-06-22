module Schedules::Validation
  extend ActiveSupport::Concern

  included do
    validates :script, :server, presence: true
    validates :start, presence: true, timeliness: { type: :datetime }
    validates :end, timeliness: { type: :datetime, after: :start }
    validates :interval, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true
    validates :frequency, inclusion: { in: %w(hourly daily weekly monthly) }, allow_blank: true
  end
end

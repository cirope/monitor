module Runs::Validation
  extend ActiveSupport::Concern

  included do
    validates :status, inclusion: { in: %w(pending running ok error) }, presence: true
    validates :scheduled_at, :schedule, presence: true
    validates :scheduled_at, :started_at, :ended_at, timeliness: { type: :datetime, on_or_after: :now }
  end
end

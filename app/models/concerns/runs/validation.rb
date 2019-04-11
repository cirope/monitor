# frozen_string_literal: true

module Runs::Validation
  extend ActiveSupport::Concern

  included do
    validates :scheduled_at, :job, :status, presence: true
    validates :pid, numericality: { only_integer: true }, allow_blank: true
    validates :scheduled_at, :started_at, :ended_at, timeliness: {
      type: :datetime
    }, allow_blank: true
  end
end

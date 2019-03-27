# frozen_string_literal: true

module Runs::Validation
  extend ActiveSupport::Concern

  included do
    validates :status, inclusion: { in: status_list }, presence: true
    validates :scheduled_at, :job, presence: true
    validates :scheduled_at, :started_at, :ended_at, timeliness: { type: :datetime }, allow_blank: true
    validates :pid, numericality: { only_integer: true }, allow_blank: true
  end

  module ClassMethods
    private

      def status_list
        %w(pending scheduled running ok error canceled aborted)
      end
  end
end

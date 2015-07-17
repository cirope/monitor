module Runs::Validation
  extend ActiveSupport::Concern

  included do
    validates :status, inclusion: { in: status_list }, presence: true
    validates :scheduled_at, :schedule, presence: true
    validates :scheduled_at, :started_at, :ended_at, timeliness: { type: :datetime }, allow_blank: true
  end

  module ClassMethods
    private

      def status_list
        %w(pending scheduled running ok error canceled)
      end
  end
end

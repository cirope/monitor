module Issues::Validation
  extend ActiveSupport::Concern

  included do
    validates :status, presence: true, inclusion: { in: :next_status }
  end
end

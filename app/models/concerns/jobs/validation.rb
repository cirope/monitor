module Jobs::Validation
  extend ActiveSupport::Concern

  included do
    validates :script, :server, presence: true
  end
end

module ControlOutputs::Validation
  extend ActiveSupport::Concern

  included do
    validates :status, presence: true
  end
end

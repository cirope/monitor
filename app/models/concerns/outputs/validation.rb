module Outputs::Validation
  extend ActiveSupport::Concern

  included do
    validates :run, presence: true
  end
end

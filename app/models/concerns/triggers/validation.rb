module Triggers::Validation
  extend ActiveSupport::Concern

  included do
    validates :callback, presence: true
  end
end

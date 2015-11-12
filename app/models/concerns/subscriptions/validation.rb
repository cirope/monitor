module Subscriptions::Validation
  extend ActiveSupport::Concern

  included do
    validates :user, presence: true
  end
end

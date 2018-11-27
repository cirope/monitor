module Executions::Validation
  extend ActiveSupport::Concern

  included do
    validates :script, :server, :user, presence: true
  end
end

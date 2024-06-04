module Executions::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order status: :desc }
  end
end

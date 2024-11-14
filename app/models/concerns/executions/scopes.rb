module Executions::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order started_at: :desc }
  end
end

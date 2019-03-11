# frozen_string_literal: true

module Executions::Validation
  extend ActiveSupport::Concern

  included do
    validates :script, :server, :user, presence: true
    validate :server_should_be_local
  end

  private

    def server_should_be_local
      errors.add :server, :should_be_local unless server&.local?
    end
end

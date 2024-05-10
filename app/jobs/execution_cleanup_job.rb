# frozen_string_literal: true

class ExecutionCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Execution.cleanup
  end
end

# frozen_string_literal: true

class ExecutionCleanupJob < ApplicationJob
  queue_as :default

  def perform script
    script.cleanup
  end
end

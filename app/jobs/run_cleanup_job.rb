# frozen_string_literal: true

class RunCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Run.cleanup
  end
end

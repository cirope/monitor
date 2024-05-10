# frozen_string_literal: true

class ScriptCleanupJob < ApplicationJob
  queue_as :default

  def perform script
    script.cleanup
  end
end

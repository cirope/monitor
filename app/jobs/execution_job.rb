# frozen_string_literal: true

class ExecutionJob < ApplicationJob
  queue_as :default

  def perform execution_id
    execution = Execution.find execution_id

    execution.with_measure { execution.run }
  end
end

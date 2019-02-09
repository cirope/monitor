class ExecutionJob < ApplicationJob
  queue_as :default

  def perform execution_id
    execution = Execution.find execution_id

    execution.run
  end
end

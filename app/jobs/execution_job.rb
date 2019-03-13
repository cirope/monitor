class ExecutionJob < ApplicationJob
  queue_as :default

  def perform execution_id
    status = system(
      "rails runner -e #{Rails.env} 'Execution.find(#{execution_id}).run_with_profiler'"
    )

    raise Exception, 'can not run_with_profiler' unless status
  end
end

class ExecutionJob < ApplicationJob
  queue_as :default

  def perform execution_id
    p Process.pid
    p system("rails runner -e #{Rails.env} 'Execution.find(#{execution_id}).manso && raise Exception'")

    # execution = Execution.find execution_id

    # execution.run
  end
end

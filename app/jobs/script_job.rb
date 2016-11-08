class ScriptJob < ApplicationJob
  queue_as :default

  def perform run
    return if run.canceled?

    Run.transaction do
      run.should_be_canceled? ? run.cancel : run.execute
      run.execute_triggers
    end
  end
end

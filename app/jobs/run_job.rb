# frozen_string_literal: true

class RunJob < ApplicationJob
  queue_as :default

  def perform run
    return if run.canceled?

    if run.should_be_canceled?
      run.cancel
    else
      run.execute
    end

    run.execute_triggers
  end
end

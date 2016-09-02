class ScriptJob < ApplicationJob
  queue_as :default

  def perform run
    return if run.canceled?

    run.should_be_canceled? ? run.cancel : execute(run)
  end

  private

    def execute run
      job      = run.job
      schedule = run.schedule

      run.mark_as_running

      Run.transaction do
        out  = { status: 'canceled' }
        out  = job.server.execute job.script if schedule.run?
        data = ActiveSupport::JSON.decode out[:output] rescue nil

        run.finish status: out[:status], output: out[:output], data: data

        run.execute_triggers
      end
    end
end

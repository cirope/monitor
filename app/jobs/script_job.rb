class ScriptJob < ActiveJob::Base
  queue_as :default

  def perform run
    schedule = run.schedule

    ScheduleJob.perform_later schedule

    run.update! status: 'running', started_at: Time.now

    Run.transaction do
      out = { status: 'canceled' }

      out = schedule.server.execute schedule.script if schedule.run?

      run.update! status: out[:status], output: out[:output], ended_at: Time.now
    end
  end
end

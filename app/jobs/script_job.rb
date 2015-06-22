class ScriptJob < ActiveJob::Base
  queue_as :default

  def perform run
    Run.transaction do
      schedule = run.schedule

      run.update! status: 'running', started_at: Time.now

      schedule.build_next_run

      out = schedule.server.execute schedule.script

      run.update! status: out[:status], output: out[:output], ended_at: Time.now
    end
  end
end

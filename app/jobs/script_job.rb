class ScriptJob < ActiveJob::Base
  queue_as :default

  def perform run
    job      = run.job
    schedule = run.schedule

    run.update! status: 'running', started_at: Time.now

    Run.transaction do
      out  = { status: 'canceled' }
      out  = job.server.execute job.script if schedule.run?
      data = ActiveSupport::JSON.decode out[:output] rescue nil

      run.update!(
        status:   out[:status],
        output:   out[:output],
        data:     data,
        ended_at: Time.zone.now
      )
    end
  end
end

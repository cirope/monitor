module Runs::Execution
  extend ActiveSupport::Concern

  def execute
    out  = { status: 'aborted' }
    out  = job.server.execute job.script if schedule.run?
    data = ActiveSupport::JSON.decode out[:output] rescue nil

    finish status: out[:status], output: out[:output], data: data
  end

  def should_be_canceled?
    job.runs.where.not(id: id).running.exists?
  end

  def cancel
    update! status: 'canceled', started_at: Time.zone.now, ended_at: Time.zone.now
  end

  def mark_as_running
    update! status: 'running', started_at: Time.zone.now
  end

  module ClassMethods
    def schedule
      next_to_schedule.find_each do |run|
        run.update! status: 'scheduled'

        ScriptJob.set(wait_until: run.scheduled_at).perform_later run
      end
    end

    def cancel
      update_all status: 'canceled'
    end
  end

  private

    def finish status:, output: nil, data: nil
      update! status: status, output: output, data: data, ended_at: Time.zone.now
    end
end

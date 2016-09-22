module Runs::Schedule
  extend ActiveSupport::Concern

  def should_be_canceled?
    job.runs.running.exists?
  end

  def cancel
    update! status: 'canceled', started_at: Time.zone.now, ended_at: Time.zone.now
  end

  def mark_as_running
    update! status: 'running', started_at: Time.zone.now
  end

  def finish status:, output: nil, data: nil
    update! status: status, output: output, data: data, ended_at: Time.zone.now
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
end

module Runs::Schedule
  extend ActiveSupport::Concern

  included do
    scope :pending,          -> { where status: 'pending' }
    scope :next_to_schedule, -> {
      pending.where "#{table_name}.scheduled_at <= ?", 2.minutes.from_now
    }
    scope :scheduled,        -> { where status: 'scheduled' }
    scope :overdue,          -> {
      scheduled.where "#{table_name}.scheduled_at <= ?", 1.day.ago
    }
    scope :running,          -> { where status: 'running' }
  end

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

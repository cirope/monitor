# frozen_string_literal: true

module Runs::Execution
  extend ActiveSupport::Concern

  def execute
    mark_as_running

    out  = { status: 'aborted' }
    out  = server.execute self if schedule.run?
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
      Account.on_each do
        schedule_all
      end
    end

    def cancel
      update_all status: 'canceled'
    end

    private

      def schedule_all
        next_to_schedule.find_each do |run|
          run.update! status: 'scheduled'

          RunJob.set(wait_until: run.scheduled_at).perform_later run
        end
      end
  end

  private

    def finish status:, output: nil, data: nil
      update! status: status, output: output, data: data, ended_at: Time.zone.now
    end
end

# frozen_string_literal: true

module Runs::Execution
  extend ActiveSupport::Concern

  def execute
    mark_as_running

    out  = { status: 'aborted' }
    out  = server.execute self if schedule.run?
    data = ActiveSupport::JSON.decode out[:stdout] rescue nil

    if data&.is_a?(Hash) && (series = data['series']).present?
      # Delete series key only if all series were created
      Serie.add(series) && data.delete('series')
    end

    finish status: out[:status], stdout: out[:stdout], stderr: out[:stderr], data: data
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
          run.scheduled!

          RunJob.set(wait_until: run.scheduled_at).perform_later run
        end
      end
  end

  private

    def finish status:, stdout: nil, stderr: nil, data: nil
      update!(
        status:   status,
        stdout:   stdout,
        stderr:   stderr,
        data:     data,
        ended_at: Time.zone.now
      )
    end
end

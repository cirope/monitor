module Schedules::Cleanup
  extend ActiveSupport::Concern

  def cleanup
    all_destroyed = true

    Schedule.transaction do
      cleanable_runs.find_each do |run|
        destroyed = run.destroy

        all_destroyed &&= destroyed
      end
    end

    all_destroyed
  end

  private

    def cleanable_runs
      times = case frequency
      when 'minutes'
        10
      when 'hours'
        4
      else
        1
      end

      runs.executed.or(runs.canceled).or(runs.overdue_by interval * times, frequency)
    end
end

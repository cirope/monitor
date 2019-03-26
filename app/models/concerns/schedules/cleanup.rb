# frozen_string_literal: true

module Schedules::Cleanup
  extend ActiveSupport::Concern

  def cleanup
    all_destroyed = true

    cleanable_runs.find_each do |run|
      destroyed = begin
                    run.reload.destroy
                  rescue ActiveRecord::RecordNotFound,
                         ActiveRecord::StaleObjectError
                    false
                  end

      all_destroyed &&= destroyed
    end

    all_destroyed
  end

  private

    def cleanable_runs
      runs.executed.or(runs.canceled).or(runs.aborted).or(runs.overdue)
    end
end

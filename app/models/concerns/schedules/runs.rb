module Schedules::Runs
  extend ActiveSupport::Concern

  included do
    before_create :set_scheduled_at, :create_initial_runs

    has_many :runs, -> { order :scheduled_at }, through: :jobs
  end

  def build_next_runs
    scheduled_at = next_date

    if self.end.blank? || scheduled_at <= self.end
      jobs.map do |job|
        job.runs.create! status: 'pending', scheduled_at: scheduled_at
      end
    end
  end

  def run
    scheduled_at = Time.zone.now

    jobs.each do |job|
      run = job.runs.create! status: 'scheduled', scheduled_at: scheduled_at

      ScriptJob.perform_later run
    end
  end

  def run?
    required.all? &:last_run_ok?
  end

  def last_run_ok?
    runs.executed.last.try :ok?
  end

  def next_date
    start.advance frequency.to_sym => intervals_since_start + (interval || 1)
  end

  private

    def set_scheduled_at
      self.scheduled_at = start
    end

    def create_initial_runs
      jobs.each do |job|
        job.runs.build status: 'pending', scheduled_at: start
      end
    end

    def intervals_since_start
      now = Time.zone.now

      if frequency == 'months'
        result = (now.year * 12 + now.month) - (start.year * 12 + start.month)
      else
        distance_in_minutes = ((now - start) / 60.0).truncate
        factors = {
          minutes: 1,
          hours:   60,
          days:    60 * 24,
          weeks:   60 * 24 * 7
        }

        result = (distance_in_minutes / factors[frequency.to_sym]).truncate
      end

      result > 0 ? result : 0
    end
end

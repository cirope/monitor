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

  def run?
    required.all? &:last_run_ok?
  end

  def last_run_ok?
    runs.executed.last.try :ok?
  end

  def next_date
    Time.zone.now.advance frequency.to_sym => interval
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
end

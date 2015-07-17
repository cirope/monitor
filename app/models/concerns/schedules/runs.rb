module Schedules::Runs
  extend ActiveSupport::Concern

  included do
    before_create :create_initial_run

    has_many :runs, -> { order :scheduled_at }, dependent: :destroy, autosave: true
  end

  def build_next_run
    scheduled_at = next_date

    if self.end.blank? || scheduled_at <= self.end
      runs.create! status: 'pending', scheduled_at: scheduled_at
    end
  end

  def run?
    required.all? &:last_run_ok?
  end

  def last_run_ok?
    runs.executed.last.try :ok?
  end

  private

    def create_initial_run
      runs.build status: 'pending', scheduled_at: start
    end

    def next_date
      frequencies = {
        'minutes' => :minutes,
        'hourly'  => :hours,
        'daily'   => :days,
        'weekly'  => :weeks,
        'monthly' => :months
      }

      Time.zone.now.advance frequencies[frequency] => interval
    end
end

module Schedules::Runs
  extend ActiveSupport::Concern

  included do
    before_create :create_initial_run

    has_many :runs, dependent: :destroy, autosave: true
  end

  def build_next_run
    runs.create! status: 'pending', scheduled_at: next_date
  end

  private

    def create_initial_run
      runs.build status: 'pending', scheduled_at: start
    end

    def next_date
      frequencies = {
        'hourly'  => :hours,
        'daily'   => :days,
        'weekly'  => :weeks,
        'monthly' => :months
      }

      Time.zone.now.advance frequencies[frequency] => interval
    end
end

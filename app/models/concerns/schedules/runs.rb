module Schedules::Runs
  extend ActiveSupport::Concern

  included do
    before_create :create_initial_run

    has_many :runs, dependent: :destroy, autosave: true
  end

  private

    def create_initial_run
      runs.build status: 'pending', scheduled_at: start
    end
end

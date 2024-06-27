# frozen_string_literal: true

class Schedules::JobsController < ApplicationController
  include Authentication
  include Authorization

  content_security_policy false

  before_action :set_schedule, :set_job

  def update
    @schedule.run @job

    redirect_to schedule_runs_url(@schedule)
  end

  private

    def set_schedule
      @schedule = Schedule.find params[:schedule_id]
    end

    def set_job
      @job = @schedule.jobs.find params[:id]
    end
end

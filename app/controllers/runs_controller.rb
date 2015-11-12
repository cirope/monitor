class RunsController < ApplicationController
  before_action :authorize, :not_guest
  before_action :set_title, except: [:destroy]
  before_action :set_schedule, only: [:index]
  before_action :set_run, only: [:show, :destroy]

  respond_to :html

  def index
    @runs = @schedule.runs.reorder(scheduled_at: :desc).page params[:page]

    respond_with @runs
  end

  def show
    respond_with @run
  end

  def destroy
    @run.destroy
    respond_with @run, location: schedule_runs_url(@run.schedule)
  end

  private

    def set_schedule
      @schedule = Schedule.find params[:schedule_id]
    end

    def set_run
      @run = Run.find params[:id]
    end
end

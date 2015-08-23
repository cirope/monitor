class SchedulesController < ApplicationController
  before_action :set_title, except: [:destroy]
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @schedules = Schedule.search(query: params[:q], limit: request.xhr? && 10).page params[:page]

    respond_with @schedules
  end

  def show
    respond_with @schedule
  end

  def new
    @schedule = Schedule.new

    respond_with @schedule
  end

  def edit
  end

  def create
    @schedule = Schedule.new schedule_params

    @schedule.save
    respond_with @schedule
  end

  def update
    @schedule.update schedule_params
    respond_with @schedule
  end

  def destroy
    @schedule.destroy
    respond_with @schedule
  end

  private
    def set_schedule
      @schedule = Schedule.find params[:id]
    end

    def schedule_params
      params.require(:schedule).permit :name, :start, :end, :interval, :frequency, :script_id, :server_id, :lock_version,
        dependencies_attributes: [:id, :schedule_id, :_destroy]
    end
end

# frozen_string_literal: true

class SchedulesController < ApplicationController
  include Authorization
  include Schedules::Filters

  before_action :set_title, except: [:destroy, :cleanup, :run]
  before_action :set_schedule, only: [:show, :edit, :update, :destroy, :run, :cleanup]

  def index
    @schedules = schedules.visible.page params[:page]
  end

  def show
  end

  def new
    @schedule = Schedule.new
  end

  def edit
  end

  def create
    @schedule = Schedule.new schedule_params

    if @schedule.save
      redirect_to @schedule
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @schedule.update schedule_params
      redirect_to @schedule
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    ScheduleDestroyJob.perform_later @schedule

    redirect_to schedules_url
  end

  def run
    @schedule.run

    redirect_to schedule_runs_url(@schedule)
  end

  def cleanup
    ScheduleCleanupJob.perform_later @schedule

    redirect_to @schedule
  end

  private

    def set_schedule
      @schedule = Schedule.find params[:id]
    end

    def schedule_params
      params.require(:schedule).permit :name, :start, :end, :interval, :frequency, :lock_version,
        jobs_attributes: [:id, :server_id, :script_id, :_destroy],
        dependencies_attributes: [:id, :schedule_id, :_destroy],
        dispatchers_attributes: [:id, :rule_id, :_destroy]
    end
end

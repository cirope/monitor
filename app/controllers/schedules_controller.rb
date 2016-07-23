class SchedulesController < ApplicationController
  include Schedules::Filters

  before_action :authorize, :not_guest, :not_security
  before_action :set_title, except: [:destroy]
  before_action :set_schedule, only: [:show, :edit, :update, :destroy, :run, :cleanup]
  before_action :not_author, except: [:index, :show, :run]

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

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to @schedule, notice: t('flash.actions.create.notice', resource_name: Schedule.model_name.human) }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1
  def update
    respond_to do |format|
      if update_resource @schedule, schedule_params
        format.html { redirect_to @schedule, notice: t('flash.actions.update.notice', resource_name: Schedule.model_name.human) }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  def destroy
    ScheduleDestroyJob.perform_later @schedule

    respond_to do |format|
      format.html { redirect_to schedules_url, notice: t('flash.schedules.destroy.notice') }
      format.json { head :no_content }
    end
  end

  def run
    @schedule.run

    respond_to do |format|
      format.html { redirect_to schedule_runs_url(@schedule), notice: t('flash.schedules.run.notice') }
      format.json { head :no_content }
    end
  end

  def cleanup
    ScheduleCleanupJob.perform_later @schedule

    respond_to do |format|
      format.html { redirect_to @schedule, notice: t('flash.schedules.cleanup.notice') }
      format.json { head :no_content }
    end
  end

  private

    def set_schedule
      @schedule = Schedule.find params[:id]
    end

    def schedule_params
      params.require(:schedule).permit :name, :start, :end, :interval, :frequency, :lock_version,
        jobs_attributes: [:id, :server_id, :script_id, :_destroy],
        taggings_attributes: [:id, :tag_id, :_destroy],
        dependencies_attributes: [:id, :schedule_id, :_destroy],
        dispatchers_attributes: [:id, :rule_id, :_destroy]
    end
end

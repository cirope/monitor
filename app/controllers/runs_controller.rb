class RunsController < ApplicationController
  include Runs::Filters

  before_action :authorize, :not_guest
  before_action :set_title, except: [:destroy]
  before_action :set_schedule, only: [:index]
  before_action :set_run, only: [:show, :destroy]
  before_action :not_author, except: [:index, :show]

  def index
    @runs = runs.reorder(scheduled_at: :desc).page params[:page]
  end

  def show
  end

  def destroy
    respond_to do |format|
      if @run.destroy
        format.html { redirect_to schedule_runs_url(@run.schedule), notice: t('flash.runs.destroy.notice') }
        format.json { head :no_content }
      else
        format.html { redirect_to schedule_runs_url(@run.schedule), alert: t('flash.runs.destroy.alert') }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_schedule
      @schedule = Schedule.find params[:schedule_id]
    end

    def set_run
      @run = Run.find params[:id]
    end
end

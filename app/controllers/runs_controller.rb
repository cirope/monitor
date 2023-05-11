# frozen_string_literal: true

class RunsController < ApplicationController
  include Authentication
  include Authorization
  include Runs::Filters

  content_security_policy false

  before_action :set_title, except: [:destroy]
  before_action :set_schedule, only: [:index]
  before_action :set_run, only: [:show, :update, :destroy]

  def index
    @runs = runs.preload(:script).reorder(scheduled_at: :desc).page params[:page]
  end

  def show
    @measures = @run.measures.reorder(created_at: :desc).limit 30
  end

  def update
    @killed = if params[:force]
                @run.force_kill
              else
                @run.kill
              end
  end

  def destroy
    @run.destroy

    redirect_to schedule_runs_url(@run.schedule)
  end

  private

    def set_schedule
      @schedule = Schedule.find params[:schedule_id]
    end

    def set_run
      @run = Run.find params[:id]
    end
end

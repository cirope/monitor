# frozen_string_literal: true

class RunsController < ApplicationController
  include Runs::Filters

  before_action :authorize, :not_guest, :not_security
  before_action :set_title, except: [:destroy]
  before_action :set_schedule, only: [:index]
  before_action :set_run, only: [:show, :update, :destroy]
  before_action :not_author, except: [:index, :update, :show]

  respond_to :html, :js

  def index
    @runs = runs.preload(:script).reorder(scheduled_at: :desc).page params[:page]

    respond_with @runs
  end

  def show
    @measures = @run.measures.reorder(created_at: :desc).limit 30

    respond_with @run
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

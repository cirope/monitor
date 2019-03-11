# frozen_string_literal: true

class RunsController < ApplicationController
  include Runs::Filters

  before_action :authorize, :not_guest
  before_action :set_title, except: [:destroy]
  before_action :set_schedule, only: [:index]
  before_action :set_run, only: [:show, :destroy]
  before_action :not_author, except: [:index, :show]

  respond_to :html, :js

  def index
    @runs = runs.reorder(scheduled_at: :desc).page params[:page]

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

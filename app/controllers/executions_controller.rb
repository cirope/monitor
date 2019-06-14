# frozen_string_literal: true

class ExecutionsController < ApplicationController
  respond_to :html

  before_action :authorize, :not_guest, :not_security, :set_script
  before_action :set_server, only: [:create]
  before_action :set_execution, only: [:show, :update]

  # GET /executions
  def index
    @executions = @script.executions.order(started_at: :desc).page params[:page]
  end

  # GET /executions/1
  def show
    @measures = @execution.measures.reorder(created_at: :desc).limit 100
  end

  # POST /executions
  def create
    @execution = @script.executions.build execution_params

    @execution.save

    respond_with @script, @execution
  end

  def update
    if params[:force]
      @execution.force_kill
    else
      @execution.kill
    end
  end

  private

    def set_script
      @script = Script.find params[:script_id]
    end

    def set_execution
      @execution = @script.executions.find params[:id]
    end

    def set_server
      @server = Server.default.take!
    end

    def execution_params
      {
        user:   current_user,
        server: @server
      }
    end
end

# frozen_string_literal: true

class ExecutionsController < ApplicationController
  include Authentication
  include Authorization

  content_security_policy false

  before_action :set_script
  before_action :set_server, only: [:create]
  before_action :set_execution, only: [:show, :update, :destroy]

  # GET /executions
  def index
    @executions = @script.executions.order(started_at: :desc).page params[:page]
  end

  # GET /executions/1
  def show
    @measures = @execution.measures.reorder(created_at: :desc).limit 30
  end

  # POST /executions
  def create
    @execution = @script.executions.build execution_params

    @execution.save

    redirect_to [@script, @execution]
  end

  def update
    if params[:force]
      @execution.force_kill
    else
      @execution.kill
    end
  end

  def destroy
    @execution.destroy

    redirect_back fallback_location: [@script, @execution]
  end

  def cleanup
    if current_user.can? :remove, controller_path
      ScriptCleanupJob.perform_later @script
    end

    redirect_to @script
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

class ExecutionsController < ApplicationController
  respond_to :html

  before_action :authorize, :set_script

  # GET /executions
  def index
    @executions = @script.executions.page params[:page]
  end

  # GET /executions/1
  def show
    @execution = @script.executions.find params[:id]
  end

  # POST /executions
  def create
    @execution = @script.executions.build execution_params

    @execution.save

    respond_with @script, @execution
  end

  private

    def set_script
      @script = Script.find params[:script_id]
    end

    def execution_params
      {
        user:   current_user,
        server: Server.default.take!
      }
    end
end

class ExecutionsController < ApplicationController
  respond_to :html, :json

  before_action :authorize
  before_action :set_title, except: [:destroy]
  before_action :set_script

  # GET /executions
  def index
    @executions = @script.executions.page(params[:page])
  end

  # GET /executions/1
  def show
    @execution = @script.executions.find(params[:id])
  end

  # GET /executions/new
  def new
    @execution = @script.executions.build
  end

  # POST /executions
  def create
    @execution = @script.executions.build(execution_params)
    @execution.user_id = current_user.try(:id)

    @execution.save

    respond_with @script, @execution
  end

  private

    def set_script
      @script = Script.find(params[:script_id])
    end

    def execution_params
      params.require(:execution).permit :server_id
    end
end

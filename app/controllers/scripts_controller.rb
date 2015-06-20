class ScriptsController < ApplicationController
  before_action :set_script, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scripts = Script.all

    respond_with @scripts
  end

  def show
    respond_with @script
  end

  def new
    @script = Script.new

    respond_with @script
  end

  def edit
  end

  def create
    @script = Script.new script_params

    @script.save
    respond_with @script
  end

  def update
    @script.update script_params
    respond_with @script
  end

  def destroy
    @script.destroy
    respond_with @script
  end

  private
    def set_script
      @script = Script.find params[:id]
    end

    def script_params
      params.require(:script).permit :name, :file, :file_cache, :text
    end
end

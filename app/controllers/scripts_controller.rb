class ScriptsController < ApplicationController
  include Scripts::Filters

  before_action :authorize, :not_guest, :not_security
  before_action :set_title, except: [:destroy]
  before_action :set_script, only: [:show, :edit, :update, :destroy]
  before_action :check_if_can_edit, only: [:edit, :update, :destroy]

  def index
    @scripts = scripts.order(:id).page params[:page]
  end

  def show
    respond_to do |format|
      format.html
      format.json
      format.pdf  { render pdf: @script }
    end
  end

  def new
    @script = Script.new
  end

  def edit
  end

  def create
    @script = Script.new script_params

    respond_to do |format|
      if @script.save
        format.html { redirect_to @script, notice: t('flash.actions.create.notice', resource_name: Script.model_name.human) }
        format.json { render :show, status: :created, location: @script }
      else
        format.html { render :new }
        format.json { render json: @script.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scripts/1
  def update
    respond_to do |format|
      if update_resource @script, script_params
        format.html { redirect_to @script, notice: t('flash.actions.update.notice', resource_name: Script.model_name.human) }
        format.json { render :show, status: :ok, location: @script }
      else
        format.html { render :edit }
        format.json { render json: @script.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scripts/1
  def destroy
    respond_to do |format|
      if @script.destroy
        format.html { redirect_to scripts_url, notice: t('flash.actions.destroy.notice', resource_name: Script.model_name.human) }
        format.json { head :no_content }
      else
        format.html { redirect_to scripts_url, alert: t('flash.actions.destroy.alert', resource_name: Script.model_name.human) }
        format.json { render json: @script.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_script
      @script = Script.find params[:id]
    end

    def script_params
      params.require(:script).permit :name, :core, :file, :file_cache, :text,
        :change, :lock_version,
        maintainers_attributes: [:id, :user_id, :_destroy],
        descriptions_attributes: [:id, :name, :value, :_destroy],
        parameters_attributes: [:id, :name, :value, :_destroy],
        requires_attributes: [:id, :script_id, :_destroy],
        taggings_attributes: [:id, :tag_id, :_destroy]
    end

    def check_if_can_edit
      unless @script.can_be_edited_by? current_user
        redirect_to scripts_url, alert: t('messages.not_allowed')
      end
    end
end

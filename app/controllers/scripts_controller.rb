# frozen_string_literal: true

class ScriptsController < ApplicationController
  include Scripts::Filters

  before_action :authorize, :not_guest, :not_owner, :not_manager, :not_security
  before_action :set_title, except: [:destroy]
  before_action :set_script, only: [:show, :edit, :update, :destroy]
  before_action :set_server, only: [:show]
  before_action :check_if_can_edit, only: [:edit, :update, :destroy]

  respond_to :html, :json, :pdf

  def index
    @scripts = scripts.order(:id).page params[:page]

    respond_with @scripts
  end

  def show
    respond_with @script
  end

  def new
    @script = Script.new language: params[:lang]

    respond_with @script
  end

  def edit
    respond_with @script
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

    respond_with @script, location: scripts_url
  end

  private

    def set_script
      @script = Script.find params[:id]
    end

    def set_server
      @server = Server.default.take
    end

    def script_params
      params.require(:script).permit :name, :core, :attachment, :text, :change,
        :language, :database_id, :import_type, :lock_version,
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

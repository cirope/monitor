# frozen_string_literal: true

class ScriptsController < ApplicationController
  include Authentication
  include Authorization
  include Scripts::Filters
  include Tickets::Scoped

  content_security_policy false

  before_action :set_title, except: [:destroy]
  before_action :set_script, only: [:show, :edit, :update, :destroy]
  before_action :set_server, only: [:show]
  before_action :check_if_can_edit, only: [:edit, :update, :destroy]

  def index
    @scripts = scripts.order(:id).page params[:page]
  end

  def show
    respond_to do |format|
      format.pdf { render_pdf @script }
      format.any :html, :json
    end
  end

  def new
    @script = Script.new language: params[:lang]
  end

  def edit
  end

  def create
    @script = Script.new script_params.merge(tickets: Array(@ticket))

    if @script.save
      redirect_to @script
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @script.update script_params
      redirect_to @script
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @script.destroy

    redirect_to scripts_url
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
        :language, :database_id, { documents: [] }, :lock_version,
        libraries_attributes: [:id, :name, :options, :_destroy],
        maintainers_attributes: [:id, :user_id, :_destroy],
        descriptions_attributes: [:id, :name, :value, :public, :_destroy],
        parameters_attributes: [:id, :name, :value, :_destroy],
        requires_attributes: [:id, :script_id, :_destroy],
        taggings_attributes: [:id, :tag_id, :_destroy],
        documents_attachments_attributes: [:id, :_destroy],
        variables_attributes: [:id, :name, :value, :_destroy]
    end

    def check_if_can_edit
      unless @script.can_be_edited_by? current_user
        redirect_to scripts_url, alert: t('messages.not_allowed')
      end
    end
end

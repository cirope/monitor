class ServersController < ApplicationController
  include Servers::Filters

  before_action :authorize, :not_guest, :not_author
  before_action :set_title, except: [:destroy]
  before_action :set_server, only: [:show, :edit, :update, :destroy]
  before_action :not_supervisor, except: [:index, :show]

  def index
    @servers = servers.order(:id).page params[:page]
  end

  def show
  end

  def new
    @server = Server.new
  end

  def edit
  end

  def create
    @server = Server.new server_params

    respond_to do |format|
      if @server.save
        format.html { redirect_to @server, notice: t('flash.actions.create.notice', resource_name: Server.model_name.human) }
        format.json { render :show, status: :created, location: @server }
      else
        format.html { render :new }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servers/1
  def update
    respond_to do |format|
      if update_resource @server, server_params
        format.html { redirect_to @server, notice: t('flash.actions.update.notice', resource_name: Server.model_name.human) }
        format.json { render :show, status: :ok, location: @server }
      else
        format.html { render :edit }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  def destroy
    respond_to do |format|
      if @server.destroy
        format.html { redirect_to servers_url, notice: t('flash.actions.destroy.notice', resource_name: Server.model_name.human) }
        format.json { head :no_content }
      else
        format.html { redirect_to @server, alert: t('flash.servers.destroy.alert') }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_server
      @server = Server.find params[:id]
    end

    def server_params
      params.require(:server).permit :name, :hostname, :user, :password, :credential, :credential_cache, :lock_version
    end
end

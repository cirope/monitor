class ServersController < ApplicationController
  before_action :set_title, except: [:destroy]
  before_action :set_server, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @servers = Server.search(query: params[:q]).order(:id).page(params[:page])

    respond_with @servers
  end

  def show
    respond_with @server
  end

  def new
    @server = Server.new

    respond_with @server
  end

  def edit
  end

  def create
    @server = Server.new server_params

    @server.save
    respond_with @server
  end

  def update
    @server.update server_params
    respond_with @server
  end

  def destroy
    @server.destroy
    respond_with @server
  end

  private
    def set_server
      @server = Server.find params[:id]
    end

    def server_params
      params.require(:server).permit :name, :hostname, :user, :password, :credential, :credential_cache, :lock_version
    end
end

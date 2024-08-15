# frozen_string_literal: true

class ServersController < ApplicationController
  include Authentication
  include Authorization
  include Servers::Filters

  content_security_policy false

  before_action :set_title, except: [:destroy]
  before_action :set_server, only: [:show, :edit, :update, :destroy]

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

    if @server.save
      redirect_to @server
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @server.update server_params
      redirect_to @server
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @server.destroy

    redirect_to @server
  end

  private
    def set_server
      @server = Server.find params[:id]
    end

    def server_params
      params.require(:server).permit :name,
                                     :hostname,
                                     :user,
                                     :password,
                                     :key,
                                     :default,
                                     :lock_version
    end
end

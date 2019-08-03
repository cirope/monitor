class Servers::DefaultController < ApplicationController
  before_action :authorize, :not_guest, :not_author
  before_action :set_server
  before_action :not_supervisor

  respond_to :js

  def update
    @default_server = Server.default.first
    @server.update default: true
  end

  private
    def set_server
      @server = Server.find params[:server_id]
    end
end

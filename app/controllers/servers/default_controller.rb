# frozen_string_literal: true

class Servers::DefaultController < ApplicationController
  before_action :authorize, :only_security
  before_action :set_server

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

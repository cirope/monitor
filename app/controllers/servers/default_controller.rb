# frozen_string_literal: true

class Servers::DefaultController < ApplicationController
  include Authentication
  include Authorization

  before_action :set_server

  def update
    @default_server = Server.default.first
    @server.update default: true
  end

  private

    def set_server
      @server = Server.find params[:server_id]
    end
end

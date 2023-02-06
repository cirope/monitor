# frozen_string_literal: true
class SystemMonitorsController < ApplicationController
  include Authorization

  def index
    @processes = SystemProcess.user_top
  end

  def destroy
    SystemProcess.new(params[:id]).kill

    redirect_to system_monitors_path, notice: t('.destroyed')
  rescue
    redirect_to system_monitors_path, notice: t('.cannot_be_destroyed')
  end
end

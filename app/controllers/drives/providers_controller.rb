# frozen_string_literal: true

class Drives::ProvidersController < ApplicationController

  before_action :set_drive

  def index
    begin
      if @drive.update_config params[:code]

        redirect_to @drive, notice: t('.success', scope: :flash)
      else
        redirect_to @drive, alert: t('.invalid', scope: :flash)
      end
    rescue
      redirect_to @drive, alert: t('.invalid', scope: :flash)
    end
  end

  private

    def set_drive
      @drive = Drive.find_by identifier: params[:state]
    end
end

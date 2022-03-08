# frozen_string_literal: true
class ProcessesController < ApplicationController
  before_action :authorize, :not_guest, :not_owner, :not_manager
  before_action :only_supervisor, only: :destroy

  def index
    @processes = SystemProcess.user_top
  end

  def destroy
    SystemProcess.new(params[:id]).kill

    redirect_to processes_path, notice: t('.destroyed')
  rescue
    redirect_to processes_path, notice: t('.cannot_be_destroyed')
  end
end

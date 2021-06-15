# frozen_string_literal: true

class Scripts::ImportsController < ApplicationController
  before_action :authorize, :not_guest, :not_owner, :not_manager, :not_security
  before_action :set_title, only: [:new]

  def new
  end

  def create
    file = params[:file]

    if file.present?
      scripts_with_errors = Script.import file.tempfile.path

      redirect_to scripts_imports_new_url, scripts_with_errors && return if scripts_with_errors.present?
      redirect_to scripts_url, notice: t('.imported')
    else
      redirect_to scripts_imports_new_url, alert: t('.no_file')
    end
  rescue => ex
    logger.error ex

    redirect_to scripts_url, alert: t('.fail')
  end
end

# frozen_string_literal: true

class Scripts::ImportsController < ApplicationController
  before_action :authorize, :not_guest, :not_owner, :not_manager, :not_security
  before_action :set_title, only: [:new]

  def new
  end

  def create
    file = params[:file]

    if file.present?
      @scripts = Script.import file.tempfile.path

      if @scripts.blank?(&:valid?)
        @import_finished = false
        flash.now.alert = t('.no_scripts')

      elsif @scripts.all?(&:valid?)
        @import_finished = true
        flash.now.notice = t('.scripts_imported')

      else
        @import_finished = false
        flash.now.alert = t('.fail')

      end

    else
      flash.now.alert = t('.no_file')
    end
  end
end

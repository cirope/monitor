# frozen_string_literal: true

class Scripts::ImportsController < ApplicationController
  include Authenticate
  include Authorize

  before_action :set_title, only: [:new]

  def new
  end

  def create
    file = params[:file]

    if file.blank?
      redirect_to scripts_imports_new_url, alert: t('.no_file')
    elsif Script.file_invalid? file.tempfile.path
      redirect_to scripts_imports_new_url, alert: t('.file_invalid_extension')
    else
      import_scripts file
    end
  end

  private

    def import_scripts file
      @scripts         = Script.import file.tempfile.path
      @import_finished = @scripts.all? &:valid?

      if @import_finished
        flash.now.notice = t '.scripts_imported'
      else
        flash.now.alert = t '.fail'
      end
    rescue JSON::ParserError
      redirect_to scripts_imports_new_url, alert: t('.internal_format_invalid')
    end
end

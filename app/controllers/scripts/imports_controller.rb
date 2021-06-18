# frozen_string_literal: true

class Scripts::ImportsController < ApplicationController
  before_action :authorize, :not_guest, :not_owner, :not_manager, :not_security
  before_action :set_title, only: [:new]

  def new
  end

  def create
    file = params[:file]

    return redirect_to scripts_imports_new_url, alert: t('.no_file') if file.blank?

    unless Script.file_valid_extension? file.tempfile.path
      return redirect_to scripts_imports_new_url, alert: t('.file_invalid_extension')
    end

    begin
      @scripts         = Script.import file.tempfile.path
      @import_finished = @scripts.all? &:valid?

      if @import_finished
        flash.now.notice = t('.scripts_imported')
      else
        flash.now.alert = t('.fail')
      end
    rescue JSON::ParserError
      redirect_to scripts_imports_new_url, alert: t('.files_in_zip_invalids')
    end
  end
end
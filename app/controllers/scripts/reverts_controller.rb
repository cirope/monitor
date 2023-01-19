# frozen_string_literal: true

class Scripts::RevertsController < ApplicationController
  before_action :authorize
  before_action :set_script, :check_if_can_edit

  def create
    @version = @script.versions.find params[:id]

    if @script.revert_to @version
      redirect_to @script, notice: t('.reverted')
    else
      redirect_to script_version_path(@script.id, @version.id), alert: t('.cannot_be_reverted')
    end
  end

  private

    def set_script
      @script = Script.find params[:script_id]
    end

    def check_if_can_edit
      unless @script.can_be_edited_by? current_user
        redirect_to scripts_url, alert: t('messages.not_allowed')
      end
    end
end

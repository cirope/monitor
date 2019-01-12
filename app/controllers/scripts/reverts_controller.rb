class Scripts::RevertsController < ApplicationController
  before_action :authorize, :not_guest, :not_security
  before_action :set_title, only: [:create]
  before_action :set_script

  respond_to :html

  def create
    @version = @script.versions.find params[:id]

    if @script.revert_to @version
      respond_with @script, notice: t('.reverted')
    else
      redirect_to script_version_path(@script.id, @version.id), alert: t('.cannot_be_reverted')
    end
  end

  private

    def set_script
      @script = Script.find params[:script_id]
    end
end

class Scripts::VersionsController < ApplicationController
  before_action :authorize, :not_guest, :not_security
  before_action :set_title, :set_script
  before_action :set_version, only: [:show]

  respond_to :html

  def index
    @versions = @script.versions_with_text_changes.reorder(
      created_at: :desc
    ).preload(:user).page params[:page]

    respond_with @versions
  end

  def show
    respond_with @version
  end

  private

    def set_version
      @version = @script.versions.find params[:id]
    end

    def set_script
      @script = Script.find params[:script_id]
    end
end

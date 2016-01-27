class DashboardController < ApplicationController
  before_action :authorize, :not_guest
  before_action :set_title

  respond_to :html

  def index
    @scripts = Script.with_active_issues.order(:name).page params[:page]

    respond_with @scripts
  end
end

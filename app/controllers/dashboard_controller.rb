class DashboardController < ApplicationController
  before_action :authorize, :not_guest
  before_action :set_title

  helper_method :filter_params
  helper_method :issue_filter

  respond_to :html

  def index
    @scripts = scripts.order(:name).page params[:page]

    respond_with @scripts
  end

  private

    def filter_params
      params[:filter].present? ?
        params.require(:filter).permit(:name, :status, :tags) :
        {}
    end

    def issue_filter
      filter_params.slice :status, :tags
    end

    def scripts
      if params[:filter].blank?
        Script.with_active_issues
      else
        filtered_scripts
      end
    end

    def issues
      if issue_filter[:status].present?
        Issue.filter(issue_filter)
      else
        Issue.filter(issue_filter).active
      end
    end

    def filtered_scripts
      scripts = Script.filter filter_params.slice(:name)

      scripts.uniq.joins(:issues).merge issues
    end
end

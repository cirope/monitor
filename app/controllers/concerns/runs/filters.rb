module Runs::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def runs
    @schedule.runs.filter filter_params
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :status, :scheduled_at, :script_name
    else
      {}
    end
  end
end

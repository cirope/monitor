# frozen_string_literal: true

module Schedules::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def schedules
    schedules = Schedule.search query: params[:q]
    schedules = schedules.filter_by filter_params
    schedules = schedules.limit 10 if request.xhr?

    schedules
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :name, :frequency
    else
      {}
    end
  end
end

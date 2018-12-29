module Databases::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def databases
    Database.filter_by filter_params
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :name, :driver
    else
      {}
    end
  end
end

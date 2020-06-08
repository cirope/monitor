# frozen_string_literal: true

module Databases::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def databases
    databases = @account.databases
    databases = databases.search query: params[:q]
    databases = databases.filter_by filter_params
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :name, :driver
    else
      {}
    end
  end
end

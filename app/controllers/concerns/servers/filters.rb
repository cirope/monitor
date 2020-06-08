# frozen_string_literal: true

module Servers::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def servers
    servers = Server.search query: params[:q]
    servers = servers.filter_by filter_params
    servers = servers.limit 10 if request.xhr?

    servers
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :name, :hostname, :user
    else
      {}
    end
  end
end

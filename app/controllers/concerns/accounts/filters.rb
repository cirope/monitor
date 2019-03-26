# frozen_string_literal: true

module Accounts::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def accounts
    Account.filter_by filter_params
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :name, :tenant_name
    else
      {}
    end
  end
end

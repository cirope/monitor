# frozen_string_literal: true

module Accounts::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def accounts
    if current_account.default?
      Account.filter_by filter_params
    else
      Account.where(id: current_account.id)
    end
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :name, :tenant_name
    else
      {}
    end
  end
end

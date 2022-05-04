# frozen_string_literal: true

module Records::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def records
    scope.filter_by filter_params
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :date, :user
    else
      {}
    end
  end

  private

    def scope
      if params[:kind] == 'login'
        Login.all
      else
        Fail.all
      end
    end
end

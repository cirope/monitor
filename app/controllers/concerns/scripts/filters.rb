# frozen_string_literal: true

module Scripts::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def scripts
    scripts = Script.search query: params[:q], lang: params[:lang]
    scripts = scripts.filter_by filter_params
    scripts = scripts.limit 10 if request.xhr?

    scripts
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :name, :tags
    else
      {}
    end
  end
end

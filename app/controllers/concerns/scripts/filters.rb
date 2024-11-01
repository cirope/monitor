# frozen_string_literal: true

module Scripts::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def scripts
    scripts = Script.search query: params[:q], lang: params[:lang]
    scripts = scoped_scripts scripts
    scripts = scripts.limit 10 if request.xhr?

    scripts
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :name, :text, :tags
    else
      {}
    end
  end

  private

    def scoped_scripts scripts
      scripts = scripts.not_hidden if filter_params.dig(:tags).blank?

      scripts.filter_by filter_params
    end
end

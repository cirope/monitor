module Rules::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def rules
    rules = Rule.search query: params[:q]
    rules = rules.filter_by filter_params
    rules = rules.limit 10 if request.xhr?

    rules
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :name
    else
      {}
    end
  end
end

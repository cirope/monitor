# frozen_string_literal: true

module FiltersHelper
  def filters?
    filters = params[:filter]

    filters && filters.values.any?(&:present?)
  end

  def empty_message
    t filters? ? '.empty_search_html' : '.empty_html'
  end
end

# frozen_string_literal: true

module FiltersHelper
  def filters?
    filters = params[:filter]

    filters && filters.values.any?(&:present?)
  end

  def empty_message
    t filters? ? '.empty_search_html' : '.empty_html'
  end

  def start_row_in_data_filter index
    (index + 1) % 3 == 1
  end

  def end_row_in_data_filter index
    ((index + 1) % 3).zero? || index + 1 == @data_keys.count
  end
end

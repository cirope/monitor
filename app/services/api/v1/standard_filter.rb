# frozen_string_literal: true

class Api::V1::StandardFilter
  def call query:, params:
    params = params.permit filter_params
    params = ActionController::Parameters.new(default: 'default').merge params
    @query = query

    params.each do |filter_name, value|
      if respond_to?(filter_name, true)
        @query = send filter_name, value
      else
        raise ArgumentError, "Unknown filter #{filter_name}."
      end
    end

    @query
  end
end

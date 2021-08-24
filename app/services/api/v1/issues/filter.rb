# frozen_string_literal: true

class Api::V1::Issues::Filter < Api::V1::StandardFilter
  PARAMS = [:script_id, :default].freeze

  private

    def default(_value)
      @query
    end

    def script_id(script_id)
      @query.script_id_scoped script_id
    end

    def filter_params
      PARAMS
    end
end

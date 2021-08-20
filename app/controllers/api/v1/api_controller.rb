# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      private

        def response_formater(response, status)
          render json: response, status: status
        end
    end
  end
end

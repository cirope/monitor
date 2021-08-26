# frozen_string_literal: true

class Api::V1::ApiController < ActionController::API
  private

    def response_formater response
      render json: response[:data], status: response[:code]
    end
end

# frozen_string_literal: true

class Api::V1::ApiController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

    def authenticate_request
      @current_user = Api::V1::AuthorizeApiRequest.call(request.headers).result

      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end

    def response_formater response
      render json: response[:data], status: response[:code]
    end
end

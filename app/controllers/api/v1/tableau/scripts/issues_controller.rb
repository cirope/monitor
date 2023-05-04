# frozen_string_literal: true

class Api::V1::Tableau::Scripts::IssuesController < ApplicationController
  before_action :authenticate_request
  attr_reader :current_user

  layout 'tableau'

  def index
    resp = Api::V1::Scripts::Issues::Index.new.call(params, current_user)

    render json: resp[:data], status: resp[:code]
  end

  private

    def authenticate_request
      @current_user = Api::V1::AuthorizeApiRequest.call(request.headers).result

      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
end

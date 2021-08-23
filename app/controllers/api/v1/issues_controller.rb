# frozen_string_literal: true

class Api::V1::IssuesController < Api::V1::ApiController
  def index
    response_formater Api::V1::Issues::Index.new.call(params)
  end
end

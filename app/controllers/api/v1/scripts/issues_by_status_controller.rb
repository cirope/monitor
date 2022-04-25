# frozen_string_literal: true

class Api::V1::Scripts::IssuesByStatusController < Api::V1::ApiController
  def index
    response_formater Api::V1::Scripts::IssuesByStatus::Index.new.call
  end
end

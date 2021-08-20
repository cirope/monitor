# frozen_string_literal: true

module Api
  module V1
    class IssuesController < ApiController
      def index
        issue = Issue.all.first
        response_formater issue.converted_data.first.keys[0...-1], 200
      end
    end
  end
end

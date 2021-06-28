# frozen_string_literal: true

module Failures::Request
  extend ActiveSupport::Concern

  included do
    attribute :user_name, :string
    attr_accessor :request

    before_save :convert_request_into_data
  end

  private

    def convert_request_into_data
      self.data = {
        ip:                request.ip,
        remote_ip:         request.remote_ip,
        user_agent:        request.user_agent,
        user_name_failure: user_name
      }
    end
end

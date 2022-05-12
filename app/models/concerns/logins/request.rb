# frozen_string_literal: true

module Logins::Request
  extend ActiveSupport::Concern

  included do
    before_save :convert_request_into_data

    attr_accessor :request
  end

  private

    def convert_request_into_data
      if request
        self.data = {
          ip:         request.ip,
          remote_ip:  request.remote_ip,
          user_agent: request.user_agent
        }
      end
    end
end

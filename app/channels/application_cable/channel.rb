# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def stream_from_account broadcasting
      stream_from self.class.broadcasting_for_current_account(broadcasting)
    end

    def self.broadcasting_for_current_account broadcasting
      broadcasting = String(broadcasting)

      "#{Apartment::Tenant.current}:#{broadcasting}"
    end
  end
end

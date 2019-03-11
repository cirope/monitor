# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include CurrentAccount
    include CurrentUser

    alias_method :fetch_current_user,    :current_user
    alias_method :fetch_current_account, :current_account

    identified_by :current_user, :current_account

    def connect
      Apartment::Tenant.switch! Account.from_request(request)

      self.current_user    = fetch_current_user
      self.current_account = fetch_current_account

      reject_unauthorized_connection unless current_user && current_account
    end

    def disconnect
      Apartment::Tenant.switch!
    end
  end
end

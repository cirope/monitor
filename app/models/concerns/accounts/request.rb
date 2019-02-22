module Accounts::Request
  extend ActiveSupport::Concern

  module ClassMethods
    def from_request request
      request.session[:tenant_name]
    end
  end
end

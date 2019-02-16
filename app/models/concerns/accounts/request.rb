module Accounts::Request
  extend ActiveSupport::Concern

  module ClassMethods
    def from_request request
      cookie_jar = ActionDispatch::Request.new(request.env).cookie_jar

      cookie_jar.encrypted[:tenant_name]
    end
  end
end

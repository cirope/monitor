module Accounts::OnEach
  extend ActiveSupport::Concern

  module ClassMethods
    def on_each
      current = Current.account

      find_each do |account|
        Apartment::Tenant.switch account.tenant_name do
          Current.account = account

          yield account
        end
      end
    ensure
      Current.account = current
    end
  end
end

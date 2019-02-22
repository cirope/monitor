module Accounts::Tenant
  extend ActiveSupport::Concern

  included do
    after_create  :create_tenant
    after_destroy :destroy_tenant
  end

  def switch
    current = Current.account
    account = self

    Apartment::Tenant.switch tenant_name do
      Current.account = account

      yield
    end
  ensure
    Current.account = current
  end

  def switch!
    Apartment::Tenant.switch! tenant_name
  end

  private

    def create_tenant
      Apartment::Tenant.create tenant_name
    end

    def destroy_tenant
      if Apartment.connection.schema_exists? tenant_name
        Apartment::Tenant.drop tenant_name
      end
    end
end

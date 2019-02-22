module Accounts::Tenant
  extend ActiveSupport::Concern

  included do
    after_create  :create_tenant
    after_destroy :destroy_tenant
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

class CreateSeriesTenantForAccounts < ActiveRecord::Migration[6.0]
  def change
    # if (account = Account.find_by tenant_name: Apartment::Tenant.current)
    #   puts "Creating Metrics for #{account.tenant_name} tenant"

    #   Serie.create_tenant account.tenant_name
    # end
  end
end

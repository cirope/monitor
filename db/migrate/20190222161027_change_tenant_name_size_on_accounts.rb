class ChangeTenantNameSizeOnAccounts < ActiveRecord::Migration[5.2]
  def change
    change_column :accounts, :tenant_name, :string, limit: 63
  end
end

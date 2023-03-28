class AddTenantIdToDrives < ActiveRecord::Migration[7.0]
  def change
    add_column :drives, :tenant_id, :string
  end
end

class AddRolesAttributeToLdap < ActiveRecord::Migration
  def change
    add_column :ldaps, :roles_attribute, :string, null: false
  end
end

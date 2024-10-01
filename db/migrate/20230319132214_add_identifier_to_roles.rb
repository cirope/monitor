class AddIdentifierToRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :identifier, :string
    add_index :roles, :identifier, unique: true
  end
end

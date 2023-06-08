class AddPublicToDescriptors < ActiveRecord::Migration[7.0]
  def change
    add_column :descriptors, :public, :boolean, null: false, default: false
    add_column :descriptions, :public, :boolean, null: false, default: false

    add_index :descriptions, :public
  end
end

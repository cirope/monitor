class AddHiddenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hidden, :boolean, null: false, default: false

    add_index :users, :hidden
  end
end

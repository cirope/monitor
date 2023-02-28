class ChangeRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :role, :old_role

    add_reference :users, :role, index: true, foreign_key: {
      on_delete: :restrict, on_update: :restrict
    }
  end
end

class ChangeDefaultRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :old_role, true
    change_column_default :users, :old_role, nil
  end
end

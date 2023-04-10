class AddFieldsToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :title, :string

    change_column :issues, :owner_type, :string, default: nil

    change_column_null :issues, :owner_id, true
    change_column_null :issues, :owner_type, true
  end
end

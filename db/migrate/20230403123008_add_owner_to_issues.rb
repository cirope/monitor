class AddOwnerToIssues < ActiveRecord::Migration[7.0]
  def change
    rename_column :issues, :run_id, :owner_id
    add_column :issues, :owner_type, :string, default: 'Run', null: false

    remove_index :issues, :owner_id
    add_index :issues, [:owner_type, :owner_id], name: 'index_issues_on_owner'
  end
end

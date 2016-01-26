class AddActiveIssuesCountToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :active_issues_count, :integer, null: false, default: 0

    add_index :scripts, :active_issues_count
  end
end

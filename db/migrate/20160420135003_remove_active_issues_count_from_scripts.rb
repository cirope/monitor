class RemoveActiveIssuesCountFromScripts < ActiveRecord::Migration
  def change
    remove_column :scripts, :active_issues_count, :integer
  end
end

class RemoveActiveIssuesCountFromScripts < ActiveRecord::Migration[4.2]
  def change
    remove_column :scripts, :active_issues_count, :integer
  end
end

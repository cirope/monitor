class AddDescriptionIndexToIssues < ActiveRecord::Migration
  def change
    add_index :issues, :description
  end
end

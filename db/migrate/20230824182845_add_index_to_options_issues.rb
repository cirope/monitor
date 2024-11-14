class AddIndexToOptionsIssues < ActiveRecord::Migration[7.0]
  def change
     add_index :issues, :options, using: :gin
  end
end

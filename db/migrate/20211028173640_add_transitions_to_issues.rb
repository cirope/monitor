class AddTransitionsToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :transitions, :jsonb, default: {}
  end
end

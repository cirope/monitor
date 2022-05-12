class AddStateTransitionsToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :state_transitions, :jsonb, default: {}
  end
end

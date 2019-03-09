class AddStartedAtIndexToExecutions < ActiveRecord::Migration[5.2]
  def change
    add_index :executions, :started_at
  end
end

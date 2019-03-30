class AddPidToExecutionsAndRuns < ActiveRecord::Migration[5.2]
  def change
    add_column :executions, :pid, :integer
    add_column :runs, :pid, :integer
  end
end

class CreateExecutions < ActiveRecord::Migration[5.2]
  def change
    create_table :executions do |t|
      t.integer :script_id, null: false, index: true
      t.integer :server_id, null: false
      t.string :status, limit: 20, default: Execution.statuses[:pending]
      t.datetime :started_at
      t.datetime :ended_at
      t.text :output
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end

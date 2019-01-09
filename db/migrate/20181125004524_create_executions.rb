class CreateExecutions < ActiveRecord::Migration[5.2]
  def change
    create_table :executions do |t|
      t.references :script, index: true, null: false
      t.references :server, index: true, null: false
      t.string :status, default: Execution.statuses[:pending]
      t.datetime :started_at
      t.datetime :ended_at
      t.text :output
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end

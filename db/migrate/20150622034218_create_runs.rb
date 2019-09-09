# frozen_string_literal: true

class CreateRuns < ActiveRecord::Migration[4.2]
  def change
    create_table :runs do |t|
      t.string :status, index: true, null: false
      t.datetime :scheduled_at, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.datetime :started_at
      t.datetime :ended_at
      t.text :output
      t.references :schedule, index: true, null: false
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end

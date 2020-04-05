# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[4.2]
  def change
    create_table :jobs do |t|
      t.references :schedule, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :server, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :script, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end
  end
end

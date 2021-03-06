# frozen_string_literal: true

class CreateDependencies < ActiveRecord::Migration[4.2]
  def change
    create_table :dependencies do |t|
      t.references :dependent, index: true, null: false
      t.references :schedule, index: true, null: false, foreign_key: {
        on_update: :restrict,
        on_delete: :restrict
      }

      t.timestamps null: false
    end

    add_foreign_key :dependencies, :schedules, column: :dependent_id, on_update: :restrict, on_delete: :restrict
  end
end

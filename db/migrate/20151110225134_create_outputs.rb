# frozen_string_literal: true

class CreateOutputs < ActiveRecord::Migration[4.2]
  def change
    create_table :outputs do |t|
      t.text :text
      t.references :trigger, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :run, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end

    add_index :outputs, :created_at
  end
end

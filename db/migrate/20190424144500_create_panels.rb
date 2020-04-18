# frozen_string_literal: true

class CreatePanels < ActiveRecord::Migration[5.2]
  def change
    create_table :panels do |t|
      t.string :title, null: false
      t.integer :height, null: false, default: 1
      t.integer :width, null: false, default: 1
      t.string :function, null: false
      t.string :output_type, null: false
      t.string :period, null: false
      t.string :filters, array: true, default: []
      t.boolean :range, null: false, default: false
      t.string :frequency
      t.integer :start_count
      t.integer :finish_count
      t.string :from_period
      t.string :to_period
      t.references :dashboard, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end

    add_index :panels, :title
  end
end

# frozen_string_literal: true

class CreatePanels < ActiveRecord::Migration[5.2]
  def change
    create_table :panels do |t|
      t.string :title, null: false
      t.integer :height, null: false, default: 1
      t.integer :width, null: false, default: 1
      t.string :output, null: false
      t.references :dashboard, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end

    add_index :panels, :title
  end
end

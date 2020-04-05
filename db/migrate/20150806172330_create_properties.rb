# frozen_string_literal: true

class CreateProperties < ActiveRecord::Migration[4.2]
  def change
    create_table :properties do |t|
      t.string :key, null: false
      t.string :value, null: false
      t.references :database, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end
  end
end

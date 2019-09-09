# frozen_string_literal: true

class CreateScripts < ActiveRecord::Migration[4.2]
  def change
    create_table :scripts do |t|
      t.string :name, null: false
      t.string :file
      t.text :text
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end

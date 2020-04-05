# frozen_string_literal: true

class CreateDescriptors < ActiveRecord::Migration[4.2]
  def change
    create_table :descriptors do |t|
      t.string :name, null: false
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end

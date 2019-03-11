# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :tenant_name, null: false, index: { unique: true }
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end

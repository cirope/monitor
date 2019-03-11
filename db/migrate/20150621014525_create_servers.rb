# frozen_string_literal: true

class CreateServers < ActiveRecord::Migration[4.2]
  def change
    create_table :servers do |t|
      t.string :name, null: false
      t.string :hostname, null: false
      t.string :user
      t.string :password
      t.string :credential
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end

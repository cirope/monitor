# frozen_string_literal: true

class AddDefaultToServers < ActiveRecord::Migration[5.2]
  def change
    change_table :servers do |t|
      t.boolean :default, null: false, default: false
    end

    add_index :servers, :default
  end
end

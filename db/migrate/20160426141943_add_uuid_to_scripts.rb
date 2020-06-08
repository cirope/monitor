# frozen_string_literal: true

class AddUuidToScripts < ActiveRecord::Migration[4.2]
  def change
    add_column :scripts, :uuid, :uuid, null: false, default: 'md5(random()::text || clock_timestamp()::text)::uuid'

    add_index :scripts, :uuid, unique: true
  end
end

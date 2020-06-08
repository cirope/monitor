# frozen_string_literal: true

class AddUuidToTriggers < ActiveRecord::Migration[5.0]
  def change
    add_column :triggers, :uuid, :uuid, null: false, default: 'md5(random()::text || clock_timestamp()::text)::uuid'

    add_index :triggers, :uuid, unique: true
  end
end

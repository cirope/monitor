# frozen_string_literal: true

class CreateMeasures < ActiveRecord::Migration[5.2]
  def change
    create_table :measures do |t|
      t.references :measurable, index: true, polymorphic: true, null: false

      t.decimal :cpu, precision: 5, scale: 1, null: false
      t.bigint :memory_in_bytes, null: false

      t.timestamp :created_at, null: false, index: true
    end
  end
end

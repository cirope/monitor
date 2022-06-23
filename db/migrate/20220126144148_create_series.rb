# frozen_string_literal: true

class CreateSeries < ActiveRecord::Migration[6.0]
  def change
    create_table :series do |t|
      t.string   :name, index: true, null: false
      t.datetime :timestamp, index: true, null: false
      t.string   :identifier, index: true, null: false
      t.decimal  :amount, precision: 15, scale: 3, null: false
      t.jsonb    :data, index: { using: :gin }
    end
  end
end

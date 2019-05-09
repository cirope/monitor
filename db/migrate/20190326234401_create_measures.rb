class CreateMeasures < ActiveRecord::Migration[5.2]
  def change
    create_table :measures do |t|
      t.references :measureable, index: true, polymorphic: true, null: false

      t.decimal :cpu, precision: 4, scale: 1, null: false
      t.integer :memory_in_kb

      t.timestamp :created_at, null: false, index: true
    end
  end
end

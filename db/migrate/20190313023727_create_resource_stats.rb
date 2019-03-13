class CreateResourceStats < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_stats do |t|
      t.references :resourceable, index: true, polymorphic: true, null: false

      t.decimal :cpu, precision: 4, scale: 1
      t.string :memory
      t.decimal :memory_percentage, precision: 4, scale: 1

      t.timestamp :created_at, null: false
    end
  end
end

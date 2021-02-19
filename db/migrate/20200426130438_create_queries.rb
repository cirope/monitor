class CreateQueries < ActiveRecord::Migration[6.0]
  def change
    create_table :queries do |t|
      t.string :output, null: false
      t.string :function, null: false
      t.string :period
      t.string :filters, null: false, array: true, default: []
      t.string :frequency
      t.integer :from_count
      t.integer :to_count
      t.string :from_period
      t.string :to_period
      t.datetime :from_at
      t.datetime :to_at
      t.boolean :range, null: false, default: false
      t.references :panel, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps
    end
  end
end

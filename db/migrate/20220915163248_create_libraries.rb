class CreateLibraries < ActiveRecord::Migration[6.1]
  def change
    create_table :libraries do |t|
      t.string :name, null: false
      t.string :options
      t.references :script, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end

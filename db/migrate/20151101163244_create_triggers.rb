class CreateTriggers < ActiveRecord::Migration[4.2]
  def change
    create_table :triggers do |t|
      t.references :rule, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.text :callback, null: false
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end

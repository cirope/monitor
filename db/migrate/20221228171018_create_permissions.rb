class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :section, null: false, index: true
      t.boolean :read, null: false, default: false
      t.boolean :edit, null: false, default: false
      t.boolean :remove, null: false, default: false
      t.references :role, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end
  end
end

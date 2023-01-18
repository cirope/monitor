class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :section, null: false, index: true
      t.boolean :permit_read, null: false, default: false
      t.boolean :permit_edit, null: false, default: false
      t.boolean :permit_destroy, null: false, default: false
      t.boolean :admin, null: false, default: false
      t.references :role, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps
    end
  end
end

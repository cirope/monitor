class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :section, null: false, index: true
      t.boolean :read, null: false, default: false
      t.boolean :edit, null: false, default: false
      t.boolean :destroy, null: false, default: false
      t.boolean :admin, null: false, default: false
      t.references :role, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end

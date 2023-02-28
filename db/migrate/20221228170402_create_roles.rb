class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :type, null: false
      t.string :name, null: false, index: { unique: true }
      t.string :description, null: false
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end

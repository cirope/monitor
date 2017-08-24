class CreateRules < ActiveRecord::Migration[4.2]
  def change
    create_table :rules do |t|
      t.string :name, null: false
      t.boolean :enabled, default: false, null: false
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end

    add_index :rules, :name
  end
end

class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :name, null: false
      t.string :file
      t.text :text
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end

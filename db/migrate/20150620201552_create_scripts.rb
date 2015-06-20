class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :name
      t.string :file
      t.text :text
      t.integer :lock_version, default: 0, null: false

      t.timestamps
    end
  end
end

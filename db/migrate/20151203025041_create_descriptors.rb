class CreateDescriptors < ActiveRecord::Migration
  def change
    create_table :descriptors do |t|
      t.string :name, null: false
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
  end
end

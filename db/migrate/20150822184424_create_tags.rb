class CreateTags < ActiveRecord::Migration[4.2]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end

    add_index :tags, :name
  end
end

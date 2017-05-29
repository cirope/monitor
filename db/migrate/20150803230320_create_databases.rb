class CreateDatabases < ActiveRecord::Migration[4.2]
  def change
    create_table :databases do |t|
      t.string :name, null: false, index: true
      t.string :driver, null: false
      t.string :description, null: false

      t.timestamps null: false
    end
  end
end

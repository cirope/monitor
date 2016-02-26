class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.references :script, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end
  end
end

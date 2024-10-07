class CreateVariables < ActiveRecord::Migration[7.0]
  def change
    create_table :variables do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.references :script, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end
  end
end

class CreateControls < ActiveRecord::Migration[6.1]
  def change
    create_table :controls do |t|
      t.text :callback, null: false
      t.references :survey, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end

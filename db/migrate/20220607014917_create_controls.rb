class CreateControls < ActiveRecord::Migration[6.1]
  def change
    create_table :controls do |t|
      t.text :callback, null: false
      t.references :controllable, index: true, polymorphic: true, null: false
      t.string :type, null: false
      t.timestamps
    end
  end
end

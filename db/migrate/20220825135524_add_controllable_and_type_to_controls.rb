class AddControllableAndTypeToControls < ActiveRecord::Migration[6.1]
  def change
    change_table :controls do |t|
      t.references :controllable, index: true, polymorphic: true, null: false
      t.string :type, null: false
    end
  end
end

class CreateEffects < ActiveRecord::Migration[6.0]
  def change
    create_table :effects do |t|
      t.references :tag, index: true, null: false, foreign_key: {
        on_update: :restrict,
        on_delete: :restrict
      }
      t.references :implied, index: true, null: false, foreign_key: {
        to_table: :tags, on_update: :restrict, on_delete: :restrict
      }

      t.timestamps null: false
    end
  end
end

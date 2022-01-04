class CreateViews < ActiveRecord::Migration[6.0]
  def change
    create_table :views do |t|
      t.references :comment, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :user, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.timestamps null: false
    end
  end
end

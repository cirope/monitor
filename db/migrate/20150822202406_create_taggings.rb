class CreateTaggings < ActiveRecord::Migration[4.2]
  def change
    create_table :taggings do |t|
      t.references :tag, index: true, null: false, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :taggable, index: true, polymorphic: true, null: false

      t.timestamps null: false
    end
  end
end

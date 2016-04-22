class CreateMaintainers < ActiveRecord::Migration
  def change
    create_table :maintainers do |t|
      t.references :user, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :script, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end
  end
end

class CreateDispatchers < ActiveRecord::Migration
  def change
    create_table :dispatchers do |t|
      t.references :schedule, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.references :rule, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }

      t.timestamps null: false
    end
  end
end

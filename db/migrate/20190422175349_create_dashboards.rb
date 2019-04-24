class CreateDashboards < ActiveRecord::Migration[5.2]
  def change
    create_table :dashboards do |t|
      t.string :name, null: false
      t.references :user, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end

    add_index :dashboards, :name
  end
end

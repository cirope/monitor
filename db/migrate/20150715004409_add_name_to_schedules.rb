class AddNameToSchedules < ActiveRecord::Migration[4.2]
  def change
    add_column :schedules, :name, :string, null: false

    add_index :schedules, :name
  end
end

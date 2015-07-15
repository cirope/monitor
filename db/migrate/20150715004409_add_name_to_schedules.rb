class AddNameToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :name, :string, null: false

    add_index :schedules, :name
  end
end

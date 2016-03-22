class AddHiddenToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :hidden, :boolean, null: false, default: false

    add_index :schedules, :hidden
  end
end

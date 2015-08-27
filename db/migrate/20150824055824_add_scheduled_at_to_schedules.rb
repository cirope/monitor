class AddScheduledAtToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :scheduled_at, :datetime

    add_index :schedules, :scheduled_at
  end
end

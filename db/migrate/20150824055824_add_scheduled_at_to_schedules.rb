class AddScheduledAtToSchedules < ActiveRecord::Migration[4.2]
  def change
    add_column :schedules, :scheduled_at, :datetime

    add_index :schedules, :scheduled_at
  end
end

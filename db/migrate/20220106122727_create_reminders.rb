class CreateReminders < ActiveRecord::Migration[6.0]
  def change
    create_table :reminders do |t|
      t.datetime :due_at, null: false
      t.string 'status', null: false
    end
  end
end

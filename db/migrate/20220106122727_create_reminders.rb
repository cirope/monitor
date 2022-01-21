class CreateReminders < ActiveRecord::Migration[6.0]
  def change
    create_table :reminders do |t|
      t.datetime :due_at, null: false
      t.string :state_class_type, null: false
      t.jsonb :issue_status_changed
    end
  end
end

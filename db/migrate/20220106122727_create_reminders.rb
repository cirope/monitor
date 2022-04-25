class CreateReminders < ActiveRecord::Migration[6.0]
  def change
    create_table :reminders do |t|
      t.datetime :due_at, null: false, index: true
      t.string :state_class_type, null: false, index: true
      t.jsonb :transition_rules
      t.references :issue, null: false, index: true, foreign_key: {
        on_delete: :restrict, on_update: :restrict
      }
    end
  end
end

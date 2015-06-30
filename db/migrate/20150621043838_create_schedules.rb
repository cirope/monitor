class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.datetime :start, null: false
      t.datetime :end
      t.integer :interval, index: true
      t.string :frequency, index: true
      t.references :script, index: true, null: false
      t.references :server, index: true
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end

    add_foreign_key :schedules, :scripts, on_delete: :restrict, on_update: :restrict
    add_foreign_key :schedules, :servers, on_delete: :restrict, on_update: :restrict
  end
end

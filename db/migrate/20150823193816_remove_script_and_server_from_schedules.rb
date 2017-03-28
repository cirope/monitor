class RemoveScriptAndServerFromSchedules < ActiveRecord::Migration[4.2]
  def change
    change_table :schedules do |t|
      t.remove :script_id
      t.remove :server_id
    end
  end
end

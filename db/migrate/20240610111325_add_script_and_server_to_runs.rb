class AddScriptAndServerToRuns < ActiveRecord::Migration[7.0]
  def change
    add_reference :runs, :script, index: true, foreign_key: {
      on_delete: :restrict, on_update: :restrict
    }
    add_reference :runs, :server, index: true, foreign_key: {
      on_delete: :restrict, on_update: :restrict
    }
  end
end

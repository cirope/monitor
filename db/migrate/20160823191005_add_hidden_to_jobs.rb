class AddHiddenToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :hidden, :boolean, null: false, default: false

    add_index :jobs, :hidden
  end
end

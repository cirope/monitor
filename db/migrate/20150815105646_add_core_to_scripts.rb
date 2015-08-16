class AddCoreToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :core, :boolean
    add_index  :scripts, :core
  end
end

class AddNameIndexesToScriptsAndServers < ActiveRecord::Migration
  def change
    add_index :scripts, :name
    add_index :servers, :name
  end
end

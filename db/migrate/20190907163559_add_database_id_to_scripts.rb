class AddDatabaseIdToScripts < ActiveRecord::Migration[5.2]
  def change
    add_reference :scripts, :database, index: true
  end
end

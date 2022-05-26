class AddColumnImportTypeToScripts < ActiveRecord::Migration[6.0]
  def change
    change_table :scripts do |t|
      t.string :imported_as
    end
  end
end

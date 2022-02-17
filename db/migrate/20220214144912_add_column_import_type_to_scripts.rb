class AddColumnImportTypeToScripts < ActiveRecord::Migration[6.0]
  def change
    add_column :scripts, :import_type, :string
  end
end

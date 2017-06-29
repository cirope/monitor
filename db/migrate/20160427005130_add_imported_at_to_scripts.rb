class AddImportedAtToScripts < ActiveRecord::Migration[4.2]
  def change
    add_column :scripts, :imported_at, :datetime
  end
end

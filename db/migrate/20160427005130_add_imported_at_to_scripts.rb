class AddImportedAtToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :imported_at, :datetime
  end
end

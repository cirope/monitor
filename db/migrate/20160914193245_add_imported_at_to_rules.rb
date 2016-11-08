class AddImportedAtToRules < ActiveRecord::Migration[5.0]
  def change
    add_column :rules, :imported_at, :datetime
  end
end

class RemoveCodeFromDrives < ActiveRecord::Migration[6.1]
  def change
    remove_column :drives, :code
  end
end

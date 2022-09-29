class AddRootFolderIdToDrives < ActiveRecord::Migration[6.1]
  def change
    add_column :drives, :root_folder_id, :string
  end
end

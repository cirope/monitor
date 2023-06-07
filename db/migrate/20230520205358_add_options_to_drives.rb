class AddOptionsToDrives < ActiveRecord::Migration[7.0]
  def change
    remove_column :drives, :tenant_id
    remove_column :drives, :root_folder_id

    add_column :drives, :options, :jsonb
  end
end

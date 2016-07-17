class ChangeObjectInVersionsToJsonb < ActiveRecord::Migration[5.0]
  def change
    change_column :versions, :object, :jsonb
    change_column :versions, :object_changes, :jsonb
  end
end

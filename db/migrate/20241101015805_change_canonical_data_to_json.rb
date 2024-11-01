class ChangeCanonicalDataToJson < ActiveRecord::Migration[7.0]
  def change
    remove_index :issues, :canonical_data

    change_column :issues, :canonical_data, :json, using: 'canonical_data::json'
  end
end

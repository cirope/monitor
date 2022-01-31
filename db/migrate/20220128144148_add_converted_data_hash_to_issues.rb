class AddConvertedDataHashToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :converted_data_hash, :jsonb, index: { using: :gin },
      default: {}
  end
end

class AddCanonicalDataToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :canonical_data, :text
    add_index :issues, :canonical_data, using: :gin, opclass: :gin_trgm_ops
  end
end

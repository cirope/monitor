class AddCanonicalDataToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :canonical_data, :jsonb, index: { using: :gin, opclass: :gist_trgm_ops },
      default: {}
  end
end

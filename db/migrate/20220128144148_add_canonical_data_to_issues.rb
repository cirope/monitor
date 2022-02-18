class AddCanonicalDataToIssues < ActiveRecord::Migration[6.0]
  # def up
  #   return if Apartment::Tenant.current != 'public'

  #   execute 'CREATE EXTENSION "pg_trgm";'
  #   execute "ALTER TABLE #{Issue.table_name} ADD COLUMN canonical_data text;"
  #   execute "CREATE INDEX index_#{Issue.table_name}_on_canonical_data ON #{Issue.table_name} USING GIST (canonical_data gist_trgm_ops);"

  #   Account.all.each do |account|
  #     schema_name = '"' + account.tenant_name + '"'
  #     execute "ALTER TABLE #{schema_name}.#{Issue.table_name} ADD COLUMN canonical_data text;"
  #     execute "CREATE INDEX index_#{Issue.table_name}_on_canonical_data ON #{schema_name}.#{Issue.table_name} USING GIST (canonical_data gist_trgm_ops);"
  #   end
  # end

  # def down
  #   return if Apartment::Tenant.current != 'public'

  #   execute "ALTER TABLE #{Issue.table_name} DROP COLUMN canonical_data;"

  #   Account.all.each do |account|
  #     schema_name = '"' + account.tenant_name + '"'
  #     execute "ALTER TABLE #{schema_name}.#{Issue.table_name} DROP COLUMN canonical_data;"
  #   end

  #   execute 'DROP EXTENSION "pg_trgm";'
  # end
  def change
    add_column :issues, :canonical_data, :text
    add_index :issues, :canonical_data, using: 'gin', opclass: :gin_trgm_ops
  end
end

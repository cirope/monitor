class EnabledPgTrgmExtension < ActiveRecord::Migration[6.0]
  def up
    execute 'CREATE SCHEMA IF NOT EXISTS shared_extensions;'
    execute 'GRANT usage ON SCHEMA shared_extensions to public;'
    # We can't use enable_extension, there is no way to specify the schema
    execute 'CREATE EXTENSION IF NOT EXISTS pg_trgm SCHEMA shared_extensions;'
  end

  def down
    execute 'DROP EXTENSION IF EXISTS pg_trgm CASCADE;'
  end
end

namespace :db do
  desc 'Also create shared_extensions Schema'
  task extensions: :environment do
    # Create Schema
    ActiveRecord::Base.connection.execute 'CREATE SCHEMA IF NOT EXISTS shared_extensions;'
    # Enable pg_trgm
    ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS pg_trgm SCHEMA shared_extensions;'
    # Grant usage to public
    ActiveRecord::Base.connection.execute 'GRANT usage ON SCHEMA shared_extensions to public;'
  end
end

Rake::Task['db:update'].enhance do
  Rake::Task['db:extensions'].invoke
end

Rake::Task['db:test:purge'].enhance do
  Rake::Task['db:extensions'].invoke
end

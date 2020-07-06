# frozen_string_literal: true

module Series::Tentant
  extend ActiveSupport::Concern

  module ClassMethods
    def switch tenant_name
      original_search_path = connection.schema_search_path

      switch! tenant_name

      yield
    ensure
      connection.schema_search_path = original_search_path

      nil
    end

    def switch! tenant_name
      connection.schema_search_path = %{"#{tenant_name}"}

      nil
    end

    def create_tenant tenant_name
      connection.execute %{CREATE SCHEMA IF NOT EXISTS "#{tenant_name}"}

      run_migrations tenant_name
    end

    def run_migrations tenant_name
      switch! tenant_name

      MetricsSchemaMigration.create_table

      connection.migration_context.migrate
    end

    def drop_tenant tenant_name
      connection.execute %{DROP SCHEMA IF EXISTS "#{tenant_name}" CASCADE}
    end
  end
end

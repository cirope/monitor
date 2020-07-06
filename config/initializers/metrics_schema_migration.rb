class MetricsSchemaMigration < ActiveRecord::SchemaMigration
  def connection
    Serie.connection
  end
end

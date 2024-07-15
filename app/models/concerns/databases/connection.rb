module Databases::Connection
  extend ActiveSupport::Concern

  included do
    after_save :connection_test
  end

  def connection_test
    require 'odbc'

    begin
      query = 'SELECT 1'
      pool  = ODBC.connect(name)

      pool.run query

    rescue ODBC::Error => e
      errors.add :base, e.message

      raise ActiveRecord::Rollback
    end
  end
end

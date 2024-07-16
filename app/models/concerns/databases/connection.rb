module Databases::Connection
  extend ActiveSupport::Concern

  included do
    after_save :connection_test
  end

  def connection_test
    require 'odbc_utf8'

    begin
      query = query_by_driver driver

      pool  = ODBC.connect(name, user, password)

      pool.run query

    rescue ODBC::Error
      errors.add :base, I18n.t('databases.error.check_connection')

      raise ActiveRecord::Rollback
    end
  end

  private

    def query_by_driver driver
      case driver
      when /PostgreSQL Unicode/i then 'Select version();'
      when /FreeTDS/i            then 'Select @@VERSION;'
      when /sqlite/i             then 'Select sqlite_version();'
      when /Oracle/i             then 'Select * FROM v$version;'
      else
        'Select 1'
      end
    end
end

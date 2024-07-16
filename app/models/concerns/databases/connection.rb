module Databases::Connection
  extend ActiveSupport::Concern

  included do
    after_save :try_connection
  end

  def try_connection
    begin

      unless connect_by_driver(driver) == 1
        errors.add :base, I18n.t('databases.errors.try_query')

        raise ActiveRecord::Rollback
      end

    rescue ODBC::Error
      errors.add :base, I18n.t('databases.errors.check_connection')

      raise ActiveRecord::Rollback
    end
  end

  private

    def connect_by_driver driver
      if driver.downcase =~ /freetds/
        ODBC.connect(name, user, password)
      else
        ODBC.connect(name)
      end.do(query_by_driver(driver))
    end

    def query_by_driver driver
      case driver
      when /oracle/i then 'SELECT * FROM v$version;'
      else
        'SELECT 1;'
      end
    end
end

module Databases::Connection
  extend ActiveSupport::Concern

  included do
    after_save :try_connection
  end

  def try_connection
    begin

      unless connect
        errors.add :base, I18n.t('databases.errors.try_query')

        raise ActiveRecord::Rollback
      end

    rescue ODBC::Error
      errors.add :base, I18n.t('databases.errors.check_connection')

      raise ActiveRecord::Rollback
    end
  end

  private

    def connect
      pool = if driver.downcase =~ /freetds/
               ODBC.connect(name, user, password)
             else
               ODBC.connect(name)
             end

      pool.do(test_query) == 1
    end

    def test_query
      case driver
      when /oracle/i then 'SELECT 1 FROM DUAL;'
      else
        'SELECT 1;'
      end
    end
end

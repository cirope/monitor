module Databases::Connection
  extend ActiveSupport::Concern

  included do
    after_save :try_connection
  end

  def try_connection
    begin
      client = connect

      unless query client
        errors.add :base, I18n.t('databases.errors.query')

        raise ActiveRecord::Rollback
      end
    rescue ODBC::Error
      errors.add :base, I18n.t('databases.errors.connection')

      raise ActiveRecord::Rollback
    end
  end

  private

    def connect
      if driver =~ /freetds/i
        ODBC.connect name, user, password
      else
        ODBC.connect name
      end
    end

    def query client
      client.do(test_query) == 1
    end

    def test_query
      if driver =~ /oracle/i
        'SELECT 1 FROM DUAL;'
      else
        'SELECT 1;'
      end
    end
end

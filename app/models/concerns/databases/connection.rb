module Databases::Connection
  extend ActiveSupport::Concern

  included do
    after_save :test_connection
  end

  private

    def test_connection
      begin
        client = connect

        unless client.run test_query
          errors.add :base, :query

          raise ActiveRecord::Rollback
        end
      rescue ODBC::Error
        errors.add :base, :connection

        raise ActiveRecord::Rollback
      end
    end

    def connect
      if driver =~ /freetds/i
        ODBC.connect name, user, password
      else
        ODBC.connect name
      end
    end

    def test_query
      driver =~ /oracle/i ? 'SELECT 1 FROM DUAL;' : 'SELECT 1;'
    end
end

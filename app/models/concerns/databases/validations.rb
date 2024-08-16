# frozen_string_literal: true

module Databases::Validations
  extend ActiveSupport::Concern

  included do
    validates :name, uniqueness: { case_sensitive: false }
    validates :name, :driver, :description, presence: true,
      length: { maximum: 255 }
    validate :can_connect?
  end

  private

    def can_connect?
      odbc_ini_tmp = read_odbc_ini

      refresh_odbc_ini

      client = ODBC.connect name, user, password

      client.run test_query
    rescue
      write_odbc_ini odbc_ini_tmp

      errors.add :base, :connection
    ensure
      client&.disconnect
    end

    def test_query
      driver =~ /oracle/i ? 'SELECT 1 FROM DUAL;' : 'SELECT 1;'
    end
end

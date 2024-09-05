module Databases::AdaptarDrivers
  extend ActiveSupport::Concern

  def adapter_drivers
    case driver
    when /postgres/i then 'psycopg2'
    when /mysql/i    then 'PyMySQL'
    when /mssql/i    then 'pyodbc'
    when /sqlite/i   then nil
    else
      raise "Unsupported adapter for driver #{driver}"
    end
  end
end

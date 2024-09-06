module Databases::AdapterDrivers
  extend ActiveSupport::Concern

  def adapter_drivers
    case driver
    when /postgres/i then 'psycopg2'
    when /mysql/i    then 'PyMySQL'
    when /mssql/i    then 'pyodbc'
    when /freetds/i  then 'pyodbc'
    when /sqlite/i   then nil
    else
      raise "Unsupported adapter for driver #{driver}"
    end
  end


  def dialect_for
    case driver
    when /postgres/i then 'postgresql'
    when /mysql/i    then 'mysql'
    when /mssql/i    then 'mssql'
    when /freetds/i  then 'mssql'
    when /sqlite/i   then nil
    end
  end
end

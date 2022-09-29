# frozen_string_literal: true

module Databases::ActiveRecordConfig
  extend ActiveSupport::Concern

  def ar_config
    {
      adapter:  adapter,
      host:     host,
      port:     port,
      username: user,
      password: password,
      database: database
    }.inspect
  end

  def adapter_gems
    case driver
    when /postgres/i then 'pg'
    when /mysql/i    then 'mysql2'
    when /sqlite/i   then 'sqlite3'
    when /freetds/i  then ['tiny_tds', 'activerecord-sqlserver-adapter']
    when /oracle/i   then ['ruby-oci8', 'activerecord-oracle_enhanced-adapter']
    else
      raise "Unsupported adapter for driver #{driver}"
    end
  end

  private

    def adapter
      case driver
      when /postgres/i then 'postgresql'
      when /mysql/i    then 'mysql2'
      when /sqlite/i   then 'sqlite3'
      when /freetds/i  then 'sqlserver'
      when /oracle/i   then 'oracle_enhanced'
      else
        raise "Unsupported adapter for driver #{driver}"
      end
    end
end

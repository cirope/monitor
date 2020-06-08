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

    def host
      extract_host_from_server
    end

    def port
      property = properties.detect { |p| p.key =~ /\Aport/i }

      property&.value&.to_i || extract_port_from_server
    end

    def database
      property = properties.detect { |p| p.key =~ /\A(database|db)/i }

      property&.value || extract_database_from_server
    end

    def extract_host_from_server
      property = properties.detect { |p| p.key =~ /\A(host|server)/i }

      if driver =~ /oracle/i
        extract_oracle_server property&.value
      else
        property&.value
      end
    end

    def extract_port_from_server
      property = properties.detect { |p| p.key =~ /\A(host|server)/i }

      if driver =~ /oracle/i
        extract_oracle_port property&.value
      else
        property&.value
      end
    end

    def extract_database_from_server
      property = properties.detect { |p| p.key =~ /\A(host|server)/i }

      if driver =~ /oracle/i
        extract_oracle_database property&.value
      else
        property&.value
      end
    end

    def extract_oracle_server value
      if match = value.to_s.match(/\/\/([^:]+):\d+\/\w+/)
        match.to_a.last
      else
        value
      end
    end

    def extract_oracle_port value
      if match = value.to_s.match(/\/\/[^:]+:(\d+)\/\w+/)
        match.to_a.last.to_i
      else
        value
      end
    end

    def extract_oracle_database value
      if match = value.to_s.match(/\/\/[^:]+:\d+\/(\w+)/)
        "/#{match.to_a.last}"
      else
        value
      end
    end
end

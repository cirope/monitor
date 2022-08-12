# frozen_string_literal: true

module Databases::PonyConfig
  extend ActiveSupport::Concern

  def pony_config
    [
      "provider='#{provider}'",
      "host='#{host}'",
      "port='#{port}'",
      "user='#{user}'",
      "password='#{password}'",
      "database='#{database}'",
    ].join(', ')
  end

  def adapter_drivers
    case driver
    when /postgres/i then 'psycopg2'
    when /mysql/i    then 'PyMySQL'
    when /sqlite/i   then nil
    when /oracle/i   then ['cx_Oracle']
    else
      raise "Unsupported adapter for driver #{driver}"
    end
  end

  private

    def provider
      case driver
      when /postgres/i then 'postgres'
      when /mysql/i    then 'mysql'
      when /sqlite/i   then 'sqlite'
      when /oracle/i   then 'oracle'
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

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

  private

    def adapter
      if driver    =~ /postgres/i
        'postgresql'
      elsif driver =~ /mysql/i
        'mysql2'
      elsif driver =~ /sqlite/i
        'sqlite3'
      elsif driver =~ /freetds/i
        'sqlserver'
      elsif driver =~ /oracle/i
        'oracle_enhanced'
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

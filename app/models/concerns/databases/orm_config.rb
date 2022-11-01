module Databases::OrmConfig
  extend ActiveSupport::Concern

  private

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

    def encrypt_password password
      if password
        @cipher_key ||= SecureRandom.hex
        cipher      = OpenSSL::Cipher.new(GREDIT_CIPHER).encrypt
        cipher.key  = Digest::MD5.hexdigest @cipher_key
        cipher.iv   = @cipher_key[0..15]
        encrypted   = cipher.update(password) + cipher.final

        Base64.strict_encode64(encrypted)
      end
    end
end

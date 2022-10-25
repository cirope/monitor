# frozen_string_literal: true

module Databases::PonyConfig
  extend ActiveSupport::Concern

  def pony_config
    [
      "provider='#{provider}'",
      "host='#{host}'",
      "port='#{port}'",
      "user='#{user}'",
      "password='#{encrypt_password(password)}'",
      "database='#{database}'"
    ].join ', '
  end

  def adapter_drivers
    case driver
    when /postgres/i then 'psycopg2'
    when /mysql/i    then 'PyMySQL'
    when /sqlite/i   then nil
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
      else
        raise "Unsupported adapter for driver #{driver}"
      end
    end

    def encrypt_password password
      @cipher_key ||= SecureRandom.hex
      cipher      = OpenSSL::Cipher.new(GREDIT_CIPHER).encrypt
      cipher.key  = Digest::MD5.hexdigest cipher_key
      encrypted   = cipher.update(password) + cipher.final

      Base64.encode64(encrypted)
    end
end

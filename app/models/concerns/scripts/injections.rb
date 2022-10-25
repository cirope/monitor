# frozen_string_literal: true

module Scripts::Injections
  extend ActiveSupport::Concern

  ODBC_CONNECTION_REGEX = /ODBC.connect\(?\s*['"](\w+)['"]\s*\)?/
  AR_CONNECTION_REGEX   = /@@ar_connection\[['"](\w+)['"]\]/
  DB_PROPERTY_REGEX     = /@@databases\[['"](\w+)['"]\]\[['"](\w+)['"]\]/

  def text_with_injections
    lines = text.each_line.map do |line|
      if (match = line.match(ODBC_CONNECTION_REGEX)) && line[','].blank?
        connection_name = match.captures.first

        inject_db_properties line, connection_name
      elsif (match = line.match(AR_CONNECTION_REGEX))
        connection_name = match.captures.first

        inject_ar_connection line, connection_name
      elsif (match = line.match(DB_PROPERTY_REGEX))
        connection_name = match.captures.first
        property_key    = match.captures.last

        replace_db_property line, connection_name, property_key
      else
        line
      end
    end

    lines.join
  end

  private

    def inject_db_properties line, connection_name
      db = Database.current.find_by name: connection_name

      if db && db.driver.downcase =~ /freetds/ && db.user && db.password
        arguments = "'#{connection_name}', '#{db.user}', '#{db.password}'"
        new_line  = line.sub ODBC_CONNECTION_REGEX, "ODBC.connect(#{arguments})"

        "#{new_line}\r\n"
      else
        line
      end
    end

    def inject_ar_connection line, connection_name
      @db = Database.current.find_by name: connection_name

      if @db
        line.sub AR_CONNECTION_REGEX, "_ar_connection(#{@db.ar_config}, '#{@db.cipher_key}')"
      else
        line
      end
    end

    def replace_db_property line, connection_name, property_key
      db = Database.current.find_by name: connection_name

      if db && db.property(property_key)
        value = db.property property_key

        line.sub DB_PROPERTY_REGEX, "'#{value}'"
      else
        line
      end
    end
end

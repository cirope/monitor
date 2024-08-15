# frozen_string_literal: true

module Scripts::PythonInjections
  extend ActiveSupport::Concern

  PY_DB_PROPERTY_REGEX = /@databases\[['"](\w+)['"]\]\[['"](\w+)['"]\]/

  def text_with_python_injections
    lines = text.each_line.map do |line|
      if (match = line.match(PONY_CONNECTION_REGEX))
        connection_name = match.captures.first

        inject_pony_connection line, connection_name
      elsif (match = line.match(PY_GREDIT_CONNECTION_REGEX)) && line[','].blank?
        connection_name = match.captures.first

        inject_py_odbc_property line, connection_name
      elsif (match = line.match(PY_DB_PROPERTY_REGEX))
        connection_name = match.captures.first
        property_key    = match.captures.last

        replace_py_db_property line, connection_name, property_key
      else
        line
      end
    end

    lines.join
  end

  private

    def inject_pony_connection line, connection_name
      db = Database.current.find_by name: connection_name

      if db
        config    = db.pony_config # Aquí se genera el key y el iv
        cipher    = GREDIT_CIPHER.values.first
        algorithm = cipher[:algorithm] % { key: "'#{db.cipher_key}'.encode()" }
        mode      = cipher[:mode]      % {  iv:  "'#{db.cipher_iv}'.encode()" }

        connection = [
          'db = Database()',
          "db.bind(_decrypt_password(#{config}, #{algorithm}, #{mode}))"
        ].join '; '

        line.sub PONY_CONNECTION_REGEX, connection
      else
        line
      end
    end

    def inject_py_odbc_property line, connection_name
      db = Database.current.find_by name: connection_name

      if db && db.driver.downcase =~ /freetds/ && db.user && db.password
        arguments = "DSN=#{connection_name};UID=#{db.user};PWD=#{db.password}"
        new_line  = line.sub PY_GREDIT_CONNECTION_REGEX, "pyodbc.connect('#{arguments}')"

        "#{new_line}\r\n"
      else
        line
      end
    end

    def replace_py_db_property line, connection_name, property_key
      db = Database.current.find_by name: connection_name

      if db && db.property(property_key)
        value = db.property property_key

        line.sub PY_DB_PROPERTY_REGEX, "'#{value}'"
      else
        line
      end
    end
end

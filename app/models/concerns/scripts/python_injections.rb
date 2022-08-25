# frozen_string_literal: true

module Scripts::PythonInjections
  extend ActiveSupport::Concern

  PY_CONNECTION_REGEX   = /@py_connection\[['"](\w+)['"]\]/
  PY_DB_PROPERTY_REGEX  = /@databases\[['"](\w+)['"]\]\[['"](\w+)['"]\]/

  def text_with_python_injections
    lines = text.each_line.map do |line|
      if (match = line.match(PY_CONNECTION_REGEX))
        connection_name = match.captures.first

        inject_py_connection line, connection_name
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

    def inject_py_connection line, connection_name
      db = Database.current.find_by name: connection_name

      if db
        connection = [
          "db = Database()",
          "db.bind(#{db.pony_config})",
        ].join("\n\n")

        line.sub PY_CONNECTION_REGEX, connection
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

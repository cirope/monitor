module Scripts::Injections
  extend ActiveSupport::Concern

  ODBC_CONNECTION_REGEX = /ODBC.connect\(?\s*['"](\w+)['"]\s*\)?/

  def text_with_injections
    lines = text.each_line.map do |line|
      if (match = line.match(ODBC_CONNECTION_REGEX)) && line[','].blank?
        connection_name = match.captures.first

        inject_db_properties line, connection_name
      else
        line
      end
    end

    lines.join
  end

  private

    def inject_db_properties line, connection_name
      db = Database.find_by name: connection_name

      if db && db.driver.downcase == 'freetds' && db.user && db.password
        arguments = "'#{connection_name}', '#{db.user}', '#{db.password}'"

        line.sub ODBC_CONNECTION_REGEX, "ODBC.connect(#{arguments})"
      else
        line
      end
    end
end

module Databases::ODBC
  extend ActiveSupport::Concern

  included do
    after_save :refresh_odbc_ini
  end

  def odbc_string
    result = "[#{name}]\n"

    result << "Driver = #{driver}\n"
    result << "Description = #{description}\n"

    properties.each do |property|
      result << "#{property.key} = #{property.value}\n"
    end

    result
  end

  private

    def refresh_odbc_ini
      File.open("#{Etc.getpwuid.dir}/.odbc.ini", 'w') do |file|
        Database.ordered.each do |database|
          file << "#{database.odbc_string}\n"
        end
      end
    end
end

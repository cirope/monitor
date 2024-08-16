# frozen_string_literal: true

module Databases::Odbc
  extend ActiveSupport::Concern

  included do
    after_destroy :refresh_config
  end

  def read_config
    File.read config_path
  end

  def write_config content
    File.write config_path, content
  end

  def refresh_config
    File.open(config_path, 'w') do |file|
      Database.where.not(id: id).ordered.each do |database|
        file << "#{database.odbc_string}\n"
      end
      file << "#{odbc_string}\n" unless destroyed?
    end
  end

  def odbc_string
    result = "[#{name}]\n"

    result += "Driver = #{driver}\n"
    result += "Description = #{description}\n"

    properties.each do |property|
      value = property.password? ? property.password : property.value

      result += "#{property.key} = #{value}\n"
    end

    result
  end

  private

    def config_path
      "#{Etc.getpwuid.dir}/.odbc.ini"
    end
end

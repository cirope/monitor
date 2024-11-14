# frozen_string_literal: true

module Databases::PonyConfig
  extend ActiveSupport::Concern

  def pony_config
    <<~PYTHON.strip
      dict(provider='#{pony_provider}', host='#{host}', port='#{port}', user='#{user}', database='#{database}')
    PYTHON
  end

  private

    def pony_provider
      case driver
      when /postgres/i then 'postgres'
      when /mysql/i    then 'mysql'
      when /sqlite/i   then 'sqlite'
      else
        raise "Unsupported adapter for driver #{driver}"
      end
    end
end

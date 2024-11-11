module Databases::SqlalchemyConfig
  extend ActiveSupport::Concern

  def sqlalchemy_config
    <<~PYTHON.strip
      dict(drivername='#{provider}', host='#{host}', port='#{port}', username='#{user}', database='#{database}')
    PYTHON
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
      when /postgres/i then 'postgresql'
      when /mysql/i    then 'mysql'
      when /sqlite/i   then 'sqlite'
      else
        raise "Unsupported adapter for driver #{driver}"
      end
    end
end

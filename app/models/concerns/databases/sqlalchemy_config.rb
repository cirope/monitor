module Databases::SqlalchemyConfig
  extend ActiveSupport::Concern

  def sqlalchemy_config
    <<~PYTHON.strip
      dict(drivername='#{sqlalchemy_provider}', host='#{host}', port='#{port}', username='#{user}', database='#{database}')
    PYTHON
  end

  private

    def sqlalchemy_provider
      case driver
      when /postgres/i then 'postgresql'
      when /mysql/i    then 'mysql'
      when /sqlite/i   then 'sqlite'
      else
        raise "Unsupported adapter for driver #{driver}"
      end
    end
end

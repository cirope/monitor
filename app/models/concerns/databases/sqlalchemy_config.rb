module Databases::SqlalchemyConfig
  extend ActiveSupport::Concern

  def sqlalchemy_config
     <<~PYTHON
       urllib.parse.quote_plus('DRIVER={FreeTDS};Server=#{host};Database=#{database};UID=#{user};PWD=#{password};Port=#{port}')
     PYTHON
  end
end

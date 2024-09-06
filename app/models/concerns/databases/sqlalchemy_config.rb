module Databases::SqlalchemyConfig
  extend ActiveSupport::Concern

  def sqlalchemy_config
    <<~PYTHON
      dict(provider='#{provider}', host='#{host}', port='#{port}', user='#{user}', password='#{encrypt_password(password)}', database='#{database}')
    PYTHON
  end
end

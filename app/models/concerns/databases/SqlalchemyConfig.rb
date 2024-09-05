module Databases::SqlalchemyConfig
  extend ActiveSupport::Concern

  def sqlalchemy_config
    u = [user, encrypt_password(password)].join ':'
    h = [host, port].join ':'

    "#{u}#@#{h}/#{database}"
  end
end

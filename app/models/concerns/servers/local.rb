module Servers::Local
  extend ActiveSupport::Concern

  LOCALHOST = Regexp.union [
    /^127\.\d{1,3}\.\d{1,3}\.\d{1,3}$/,
    /^::1$/,
    /^0:0:0:0:0:0:0:1(%.*)?$/
  ]

  def local?
    hostname == 'localhost' || LOCALHOST =~ hostname
  end
end

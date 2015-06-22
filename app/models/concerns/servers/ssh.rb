module Servers::Ssh
  extend ActiveSupport::Concern

  def ssh_options
    options = {}

    if credential.present?
      options.merge keys: [credential.path]
    else
      options.merge password: password
    end
  end
end

# frozen_string_literal: true

module Servers::Ssh
  extend ActiveSupport::Concern

  def ssh_options options: {}
    options.merge! compression: true

    if key.attached?
      options.merge keys: [ActiveStorage::Blob.service.path_for(key.key)]
    else
      options.merge password: password
    end
  end
end

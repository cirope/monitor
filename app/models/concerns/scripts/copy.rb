# frozen_string_literal: true

module Scripts::Copy
  extend ActiveSupport::Concern

  included do
    scope :cores, -> { where core: true }
  end

  def copy_to server
    if server.local?
      path server
    else
      remote_copy server, "/tmp/script-#{uuid}#{extension}"
    end
  rescue => ex
    Rails.logger.error ex

    nil
  end

  def extension
    file.present? ? File.extname(file.path) : '.rb'
  end

  def body inclusion = false, server = nil
    body = inclusion ? '' : "#!/usr/bin/env ruby\n\n"

    body += headers(server).to_s unless inclusion
    body += dependencies.to_s
    body += variables.to_s
    body += commented_text inclusion

    body
  end

  private

    def headers server
      try "#{language}_headers", server
    end

    def dependencies
      try "#{language}_dependencies"
    end

    def variables
      try "#{language}_variables"
    end

    def commented_text inclusion = nil
      send "#{language}_commented_text", inclusion
    end

    def path server = nil
      if file.present?
        file.path
      else
        path = "/tmp/script-#{uuid}.rb"

        File.open(path, 'w') { |file| file << body(false, server) }

        path
      end
    end

    def remote_copy server, target_path
      Net::SCP.start(server.hostname, server.user, server.ssh_options) do |scp|
        scp.upload! path, target_path
      end

      target_path
    end

    def global_settings
      StringIO.new.tap do |buffer|
        buffer << "STDOUT.sync = true\n"
      end.string
    end
end

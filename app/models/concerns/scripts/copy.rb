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
    attachment.attached? ? attachment.filename.extension_with_delimiter : language_extension
  end

  def body inclusion = false, server = nil
    body = inclusion ? '' : language_inclusion

    body += headers(server).to_s unless inclusion
    body += dependencies.to_s
    body += variables if language != 'python'
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

    def language_extension
      try("#{language}_extension") || '.rb'
    end

    def language_inclusion
      try("#{language}_inclusion") || "#!/usr/bin/env ruby\n\n"
    end

    def variables
      StringIO.new.tap do |buffer|
        buffer << as_inner_varialble('parameters', parameters)
        buffer << as_inner_varialble('attributes', descriptions)
      end.string
    end

    def commented_text inclusion = nil
      send "#{language}_commented_text", inclusion
    end

    def path server = nil
      if attachment.attached?
        ActiveStorage::Blob.service.path_for attachment.key
      else
        path = "/tmp/script-#{uuid}#{language_extension}"

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

    def as_inner_varialble name, collection
      result = "#{name} ||= {}\n\n"

      collection.each do |object|
        result += "#{name}[%Q[#{object.name}]] = %Q[#{object.value}]\n"
      end

      "#{result}\n"
    end
end

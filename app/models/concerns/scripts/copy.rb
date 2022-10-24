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
    attachment.attached? ? attachment.filename.extension_with_delimiter : lang_extension
  end

  def body inclusion = false, server = nil
    body = inclusion ? '' : lang_inclusion

    body += lang_headers(server).to_s unless inclusion
    body += lang_includes.to_s
    body += lang_variables
    body += commented_text inclusion
    body += lang_db_connection.to_s

    body
  end

  private

    def lang_headers server
      try "#{language}_headers", server
    end

    def lang_libraries
      try "#{language}_libraries"
    end

    def lang_includes
      try "#{language}_includes"
    end

    def lang_extension
      try("#{language}_extension") || '.rb'
    end

    def lang_inclusion
      try("#{language}_inclusion") || "#!/usr/bin/env ruby\n\n"
    end

    def lang_variables
      try("#{language}_variables")  ||

      StringIO.new.tap do |buffer|
        buffer << as_inner_varialble('parameters', parameters)
        buffer << as_inner_varialble('attributes', descriptions)
      end.string
    end

    def commented_text inclusion = nil
      send "#{language}_commented_text", inclusion
    end

    def lang_db_connection
      try "#{language}_db_connection"
    end

    def path server = nil
      if attachment.attached?
        ActiveStorage::Blob.service.path_for attachment.key
      else
        path = "/tmp/script-#{uuid}#{lang_extension}"

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

    def ar_connection database
      if database
        <<~RUBY
          BEGIN {
            def _ar_connection
              ar_config  = #{database.ar_config}
              cipher     = OpenSSL::Cipher.new(GREDIT_CIPHER).decrypt
              cipher.key = Digest::MD5.hexdigest('#{database.cipher_key}')
              encrypted  = Base64.decode64(ar_config[:password])
              passwd     = cipher.update(encrypted) + cipher.final

              ActiveRecord::Base.establish_connection(ar_config.merge(password: passwd))
            end
          }
        RUBY
      end
    end
end

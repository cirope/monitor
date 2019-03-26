# frozen_string_literal: true

module Scripts::Copy
  extend ActiveSupport::Concern

  included do
    scope :cores, -> { where core: true }
  end

  def copy_to server
    if server.local?
      path
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

  def body inclusion = false
    body = inclusion ? '' : "#!/usr/bin/env ruby\n\n"

    unless inclusion
      body += settings
      body += cores_code
    end

    includes.each do |script|
      body += script.body('local inclusion')
    end

    body += variables
    body += commented_text(inclusion || 'script body')
  end

  private

    def path
      if file.present?
        file.path
      else
        path = "/tmp/script-#{uuid}.rb"

        File.open(path, 'w') { |file| file << body }

        path
      end
    end

    def remote_copy server, target_path
      Net::SCP.start(server.hostname, server.user, server.ssh_options) do |scp|
        scp.upload! path, target_path
      end

      target_path
    end

    def commented_text comment
      [
        "# Begin #{uuid} #{name} #{comment}",
        "#{text_with_injections}",
        "# End #{uuid} #{name} #{comment}\n\n"
      ].join("\n\n")
    end

    def settings
      StringIO.new.tap do |buffer|
        buffer << "STDOUT.sync = true\n"
      end.string
    end

    def cores_code
      StringIO.new.tap do |buffer|
        self.class.cores.where.not(id: id).distinct.each do |script|
          buffer << script.body('core inclusion')
        end
      end.string
    end

    def variables
      StringIO.new.tap do |buffer|
        buffer << as_inner_varialble('parameters', parameters)
        buffer << as_inner_varialble('attributes', descriptions)
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

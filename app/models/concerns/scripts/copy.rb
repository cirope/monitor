module Scripts::Copy
  extend ActiveSupport::Concern

  def copy_to server
    extension   = file.present? ? File.extname(file.path) : '.rb'
    remote_path = "/tmp/cirope-monitor-script-#{id}#{extension}"

    Net::SCP.start(server.hostname, server.user, server.ssh_options) do |scp|
      scp.upload! path, remote_path
    end

    remote_path
  end

  private

    def path
      if file.present?
        file.path
      else
        path = "/tmp/monitor-ruby-script-#{id}.rb"

        File.open(path, 'w') do |file|
          file << "#!/usr/bin/env ruby\n\n"
          file << text
        end

        path
      end
    end
end

module Scripts::Copy
  extend ActiveSupport::Concern

  def copy_to server
    extension   = file.present? ? File.extname(file.path) : '.rb'
    remote_path = "/tmp/cirope-monitor-script-#{id}#{extension}"

    Net::SCP.start(server.hostname, server.user, server.ssh_options) do |scp|
      scp.upload! path, remote_path
    end

    remote_path
  rescue
    nil
  end

  private

    def path
      if file.present?
        file.path
      else
        path = "/tmp/monitor-ruby-script-#{id}.rb"

        File.open(path, 'w') do |file|
          file << body
        end

        path
      end
    end

    def body
      body = "#!/usr/bin/env ruby\n\n"

      includes.each do |script|
        body << "# Begin #{script.name} inclusion\n\n"
        body << "#{script.text}\n\n"
        body << "# End #{script.name} inclusion\n\n"
      end

      body << "# Script #{name} begin\n\n"
      body << "#{text}\n\n"
      body << "# Script #{name} end\n\n"
    end
end


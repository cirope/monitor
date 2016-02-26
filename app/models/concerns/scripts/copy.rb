module Scripts::Copy
  extend ActiveSupport::Concern

  included do
    scope :cores, -> { where core: true }
  end

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

  def body inclusion = false
    body = inclusion ? '' : "#!/usr/bin/env ruby\n\n"

    body << cores_code unless inclusion

    includes.each do |script|
      body << script.body('local inclusion')
    end

    body << variables
    body << commented_text(inclusion || "script #{id} body")
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

    def commented_text comment
      [
        "# Begin #{name} #{comment}",
        "#{text}",
        "# End #{name} #{comment}\n\n"
      ].join("\n\n")
    end

    def cores_code
      String.new.tap do |buffer|
        self.class.cores.where.not(id: id).uniq.each do |script|
          buffer << script.body('core inclusion')
        end
      end
    end

    def variables
      String.new.tap do |buffer|
        buffer << as_inner_varialble('parameters', parameters)
        buffer << as_inner_varialble('attributes', descriptions)
      end
    end

    def as_inner_varialble name, collection
      result = "#{name} ||= {}\n\n"

      collection.each do |object|
        result << "#{name}[%q(#{object.name})] = %q(#{object.value})\n"
      end

      "#{result}\n"
    end
end

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

    unless inclusion
      body += settings
      body += external_gem_require if server&.local?
      body += cores_code
    end

    includes.each do |script|
      body += script.body('local inclusion')
    end

    body += variables
    body += commented_text(inclusion || 'script body')
  end

  private

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

    def external_gem_require
      StringIO.new.tap do |buffer|
        buffer << <<-RUBY
          def require lib
            begin
              super lib
            rescue LoadError => ex
              gem_command = "gem which \#{lib}"
              gem_path    = `#{search_gem_path}`.strip

              if gem_path != ''
                $: << File.dirname(gem_path)
                super lib
              else
                raise ex
              end
            end
          end
        RUBY
      end.string
    end

    def search_gem_path
      <<-RUBY
        cd ~/; (
          (#{bash_search_path})   ||
          (#{rbenv_search_path})  ||
          (#{chruby_search_path})
        ) 2>/dev/null
      RUBY
    end

    def bash_search_path
      '#{gem_command} || bash -c "#{gem_command}" || env -i bash -c "#{gem_command}"'
    end

    def rbenv_search_path
      'bash -c \'eval "$(~/.rbenv/bin/rbenv init -)" && #{gem_command}\''
    end

    def chruby_search_path
      'bash -c "source /usr/share/chruby/chruby.sh && chruby #{RUBY_VERSION} && #{gem_command}"'
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

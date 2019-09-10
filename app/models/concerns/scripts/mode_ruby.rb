# frozen_string_literal: true
module Scripts::ModeRuby
  extend ActiveSupport::Concern

  def ruby_headers server
    [
      global_settings,
      (external_gem_require if server&.local?),
      ruby_cores_code
    ].compact.join
  end

  def ruby_dependencies
    includes.map do |script|
      script.body 'local inclusion'
    end.join
  end

  def ruby_variables
    StringIO.new.tap do |buffer|
      buffer << as_ruby_inner_varialble('parameters', parameters)
      buffer << as_ruby_inner_varialble('attributes', descriptions)
    end.string
  end

  def ruby_commented_text comment = nil
    comment ||= 'script body'

    [
      "# Begin #{uuid} #{name} #{comment}",
      "#{text_with_injections}",
      "# End #{uuid} #{name} #{comment}\n\n"
    ].join("\n\n")
  end

  private

    def ruby_cores_code
      StringIO.new.tap do |buffer|
        self.class.cores.where.not(id: id).distinct.each do |script|
          buffer << script.body('core inclusion')
        end
      end.string
    end

    def as_ruby_inner_varialble name, collection
      result = "#{name} ||= {}\n\n"

      collection.each do |object|
        result += "#{name}[%Q[#{object.name}]] = %Q[#{object.value}]\n"
      end

      "#{result}\n"
    end

    def external_gem_require
      StringIO.new.tap do |buffer|
        buffer << <<-RUBY
          def require lib
            begin
              super lib
            rescue LoadError => ex
              #{handle_load_error_require}
            end
          end\n\n
        RUBY
      end.string
    end

    def handle_load_error_require
      <<-RUBY
        raise ex unless ex.to_s.match? /cannot load such file/i

        gem_command = "gem which \#{lib.split('/').first}"
        gem_path    = `#{search_gem_path}`.strip

        if gem_path != ''
          gem_dir = File.dirname gem_path

          raise ex if $:.include? gem_dir

          $: << gem_path
          super lib
        else
          raise ex
        end
      RUBY
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
end

module Scripts::ModePython
  extend ActiveSupport::Concern

  def python_headers server
    [
      python_libraries.to_s,
    ].compact.join
  end

  def python_libraries
    <<~PYTHON
      import subprocess
      import sys

      def import_or_install(library, command):
        try:
          __import__(library)
        except ImportError:
          subprocess.check_call(command, stdout=subprocess.DEVNULL)
        finally:
          __import__(library)

      #{python_import_libs}
    PYTHON
  end

  def python_includes
    includes.map do |script|
      script.body 'local inclusion'
    end.join
  end

  def python_commented_text comment = nil
    comment ||= 'script body'

    [
      "# Begin #{uuid} #{name} #{comment}",
      "#{text_with_python_injections}",
      "# End #{uuid} #{name} #{comment}\n\n"
    ].join("\n\n")
  end

  def python_extension
    '.py'
  end

  def python_inclusion
    "#!/usr/bin/env python3\n\n"
  end

  def python_variables
    StringIO.new.tap do |buffer|
      buffer << python_as_inner_varialble('parameters', parameters)
      buffer << python_as_inner_varialble('attributes', descriptions)
    end.string
  end

  private

    def python_import_libs
      libs = libraries.to_a + included_libraries.to_a

      StringIO.new.tap do |buffer|
        libs.each do |library|
          cmd = make_command library

          buffer << <<~PYTHON
            import_or_install('#{library}', #{cmd})\n
          PYTHON
        end
      end.string
    end

    def make_command library
      opts    = library.options.split(' ') << '--no-warn-script-location'
      version = opts.shift.delete(' ')
      name    = version =~ /[==,<=,>=,<,>]/ ? "#{library.name}#{version}" : library.name
      cmd     = "'#{opts.join(' ')}', '#{name}'"

      "[sys.executable, '-m', 'pip', 'install', #{cmd}]"
    end

    def python_as_inner_varialble name, collection
      result = "#{name} = {}\n\n"

      collection.each do |object|
        result += "#{name}['#{object.name}'] = '#{object.value}'\n"
      end

      "#{result}\n"
    end
end

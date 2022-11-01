module Scripts::ModePython
  extend ActiveSupport::Concern

  def python_headers server
    [
      python_libraries.to_s,
    ].compact.join
  end

  def python_libraries
    orm_libs = search_orm_libs
    libs = libraries.to_a + included_libraries.to_a + orm_libs

    if libs.present?
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

        #{python_import_libs(libs)}
        #{python_import_orm_libs(orm_libs)}
      PYTHON
    end
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

    def python_import_libs libs
      StringIO.new.tap do |buffer|
        libs.each do |library|
          cmd = make_command library

          buffer << "import_or_install('#{library}', #{cmd})\n"
        end
      end.string
    end

    def make_command library
      opts    = library.options.to_s.split(' ') << '--no-warn-script-location'
      version = opts.shift.strip if opts.first =~ /[==,<=,>=,<,>]/
      name    = version ? "#{library.name}#{version}" : library.name
      cmd     = "'#{opts.join(' ')}', '#{name}'"

      "[sys.executable, '-m', 'pip', 'install', #{cmd}]"
    end

    def python_import_orm_libs libs
      if libs.map(&:name).include? 'pony'
        <<~PYTHON
          import base64
          import hashlib
          from pony.orm import *
          from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

          def _pony_connection(pony_config, cipher_key):
            pwd = base64.b64decode(pony_config['password'])
            iv  = cipher_key[:16].encode()
            key = hashlib.md5(cipher_key.encode()).hexdigest()

            cipher    = Cipher(algorithms.AES(key.encode()), modes.CBC(iv))
            decryptor = cipher.decryptor()
            password  = decryptor.update(pwd) + decryptor.finalize()

            pony_config.update(password=password.decode().strip())

            return pony_config
        PYTHON
      end
    end

    def python_as_inner_varialble name, collection
      result = "#{name} = {}\n\n"

      collection.each do |object|
        result += "#{name}['#{object.name}'] = '#{object.value}'\n"
      end

      "#{result}\n"
    end

    def search_orm_libs
      libs = []

      text.each_line.map do |line|
        if (match = line.match(PONY_CONNECTION_REGEX))
          connection_name = match.captures.first

          if db = Database.current.find_by(name: connection_name)
            libs |= ['pony', 'cryptography', db.adapter_drivers]
          end
        end
      end

      libs.map { |lib| Library.new(name: lib) }
    end
end

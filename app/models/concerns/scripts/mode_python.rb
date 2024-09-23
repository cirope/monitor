module Scripts::ModePython
  extend ActiveSupport::Concern

  def python_headers server
    [
      python_libraries.to_s,
      add_cores_code
    ].compact.join
  end

  def python_libraries
    orm_libs   = search_orm_libs
    libs       = libraries.to_a + included_libraries.to_a + orm_libs
    libs_names = libs.map &:name

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
        #{python_import_pony   if libs_names.include? 'pony'         }
        #{python_import_pyodbc if libs_names.include? 'pyodbc'       }
        #{python_import_crypto if libs_names.include? 'cryptography' }
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
      version = opts.shift.strip if opts.first =~ /==|<=|>=|<|>/
      name    = version ? "#{library.name}#{version}" : library.name
      cmd     = "'#{opts.join(' ')}', '#{name}'"

      "['pip', 'install', #{cmd}]"
    end

    def python_import_pony
      'from pony.orm import *'
    end

    def python_import_pyodbc
      'import pyodbc'
    end

    def python_import_crypto
      <<~PYTHON
        import base64
        from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
        from cryptography.hazmat.primitives import padding

        def _unpad(data, size=128):
          padder         = padding.PKCS7(size).unpadder()
          unpadded_data  = padder.update(data)
          unpadded_data += padder.finalize()

          return unpadded_data

        def _decrypt(ct, method, mode):
          cipher    = Cipher(method, mode)
          decryptor = cipher.decryptor()

          return decryptor.update(ct) + decryptor.finalize()

        def _decrypt_password(config, method, mode):
          encrypted = base64.b64decode(config['password'])
          password  = _decrypt(encrypted, method, mode)

          config.update(password=_unpad(password).decode())

          return config
      PYTHON
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
            libs |= ['cryptography', 'pony', db.adapter_drivers]
          end
        elsif (match = line.match(PY_GREDIT_CONNECTION_REGEX))
          libs |= ['pyodbc']
        end
      end

      libs.map { |lib| Library.new name: lib }
    end
end

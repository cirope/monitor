module Compressible
  extend ActiveSupport::Concern

  module ClassMethods
    def create_zip_with filename
      ::Zip::File.open filename, Zip::File::CREATE do |zipfile|
        yield zipfile
      end
    end

    def add_file_content_to_zip(zipfile, filename, content)
      zipfile.get_output_stream(filename) { |f| f.write content } if content
    end

    def tmp_zip_file_content files = {}
      tmp_filename = Dir::Tmpname.create('monitor') {}

      create_zip_with tmp_filename do |zipfile|
        files.each do |filename, content|
          add_file_content_to_zip zipfile, filename, content
        end
      end

      File.read tmp_filename
    end
  end
end

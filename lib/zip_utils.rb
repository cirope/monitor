module ZipUtils
  extend self

  def create filename, files = {}
    ::Zip::File.open filename, Zip::File::CREATE do |zipfile|
      files.each do |f_name, content|
        zipfile.get_output_stream(f_name) { |f| f.write content }
      end
    end
  end

  def add_file_content(zipfile, filename, content)
    zipfile.get_output_stream(filename) { |f| f.write content } if content
  end

  def tmp_file_content files = {}
    tmp_filename = Dir::Tmpname.create('monitor') {}

    create tmp_filename, files

    File.read(tmp_filename)
  end
end

module Scripts::Export
  extend ActiveSupport::Concern

  module ClassMethods
    def export
      file = "#{Rails.root}/private/exports/#{SecureRandom.uuid}.zip"

      FileUtils.mkdir_p File.dirname(file)

      ::Zip::File.open file, Zip::File::CREATE do |zipfile|
        all.each do |script|
          unscoped { script.add_to_zip zipfile }
        end
      end

      file
    end
  end

  def add_to_zip zipfile
    filename = "#{uuid}.json"

    unless zipfile.find_entry filename
      zipfile.get_output_stream(filename) { |out| out.write to_json }

      requires.each { |require| require.script.add_to_zip zipfile }
    end
  end
end

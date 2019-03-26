# frozen_string_literal: true

module Scripts::Export
  extend ActiveSupport::Concern

  module ClassMethods
    def export
      file = "#{EXPORTS_PATH}/#{SecureRandom.uuid}.zip"

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

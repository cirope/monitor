# frozen_string_literal: true

module Exportable
  extend ActiveSupport::Concern

  module ClassMethods
    def export
      file = "#{export_path}/#{SecureRandom.uuid}.zip"

      ::Zip::File.open file, Zip::File::CREATE do |zipfile|
        all.each do |exportable|
          unscoped { exportable.add_to_zip zipfile }
        end
      end

      file
    end
  end

  def add_to_zip zipfile
    filename = "#{uuid}.json"

    unless zipfile.find_entry filename
      zipfile.get_output_stream(filename) { |out| out.write to_json }

      if respond_to?(:extra_exports)
        extra_exports.each { |extra| extra.add_to_zip zipfile }
      end
    end
  end
end

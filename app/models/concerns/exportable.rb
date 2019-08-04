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

    private

      def export_path subdir = nil
        path = [
          Rails.root,
          'private',
          Current.account.tenant_name,
          'exports',
          subdir
        ].compact.reduce :+

        FileUtils.mkdir_p path unless path.directory?

        path
      end
  end

  def add_to_zip zipfile
    filename = export_filename

    unless zipfile.find_entry filename
      ZipUtils.add_file_content(zipfile, filename, export_data)

      exportables.each { |extra| extra.add_to_zip zipfile } if respond_to?(:exportables)
    end
  end

  private

    def export_path subdir = nil
      self.class.send :export_path, subdir
    end
end

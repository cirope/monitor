# frozen_string_literal: true

module Exportable
  extend ActiveSupport::Concern

  included do
    include Compressible
  end

  module ClassMethods
    def export
      file = "#{export_path}/#{SecureRandom.uuid}.zip"

      create_zip_with file do |zipfile|
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
          tenant_name,
          'exports',
          subdir
        ].compact.reduce :+

        FileUtils.mkdir_p path unless path.directory?

        path
      end

      def tenant_name
        Current.account&.tenant_name || Apartment::Tenant.current
      end
  end

  def add_to_zip zipfile
    filename = export_filename

    unless zipfile.find_entry filename
      self.class.add_file_content_to_zip zipfile, filename, export_content

      exportables.each { |extra| extra.add_to_zip zipfile } if respond_to?(:exportables)
    end
  end

  private

    def export_path subdir = nil
      self.class.send :export_path, subdir
    end
end

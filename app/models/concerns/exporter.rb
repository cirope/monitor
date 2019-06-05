# frozen_string_literal: true

module Exporter
  extend ActiveSupport::Concern

  module ClassMethods
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

  private

    def export_path subdir = nil
      self.class.send :export_path, subdir
    end
end

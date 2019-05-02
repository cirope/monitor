# frozen_string_literal: true

module Issues::ExportData
  extend ActiveSupport::Concern

  CSV_OPTIONS = { col_sep: ';' }

  def export_data
    if data.present?
      base_dir = EXPORTS_PATH + SecureRandom.uuid

      FileUtils.mkdir_p base_dir

      export_to_csvs  base_dir
      zip_dir_content base_dir
    end
  end

  def add_to_zip zipfile
    filename  = sanitize_filename "#{description}_#{id}.zip"
    data_file = export_data

    zipfile.add filename, data_file if data_file

    data_file
  end

  module ClassMethods
    def export_data
      file  = "#{EXPORTS_PATH}/#{SecureRandom.uuid}.zip"
      files = []

      ::Zip::File.open file, Zip::File::CREATE do |zipfile|
        all.each { |issue| files << issue.add_to_zip(zipfile) }
      end

      data_file_path file, files
    end

    private

      def data_file_path file, files
        if files.compact.length == 1
          FileUtils.rm_r file

          file = files.compact.first
        else
          FileUtils.rm_r files.compact
        end

        file
      end
  end

  private

    def export_to_csvs base_dir
      if data.kind_of? Hash
        hash_to_csv  base_dir, description, data
      elsif data.kind_of? Array
        array_to_csv base_dir, description, data
      end
    end

    def hash_to_csv base_dir, name, hash
      compound_hash, simple_hash = *hash.partition do |k, v|
        v.kind_of?(Array) || v.kind_of?(Hash)
      end

      if simple_hash.present?
        csv_file = base_dir + sanitize_filename("#{name}.csv")

        ::CSV.open(csv_file, 'w', CSV_OPTIONS) do |csv|
          _hash = simple_hash.to_h

          csv << with_utf_bomb(_hash.keys)
          csv << _hash.values
        end
      end

      compound_hash.each do |k, v|
        if v.kind_of? Hash
          hash_to_csv  base_dir, [name, k].join('.'), v
        else
          array_to_csv base_dir, [name, k].join('.'), v
        end
      end
    end

    def array_to_csv base_dir, name, array
      compound_array, simple_array = *array.partition do |v|
        v.kind_of?(Array) || v.kind_of?(Hash)
      end
      simple_hashes_array, compound_array = *compound_array.partition do |v|
        v.kind_of?(Hash) && v.values.all? { |hv| !hv.kind_of?(Array) && !hv.kind_of?(Hash) }
      end

      if simple_array.present?
        csv_file = base_dir + sanitize_filename("#{name}_a.csv")

        ::CSV.open(csv_file, 'w', CSV_OPTIONS) do |csv|
          csv << with_utf_bomb([name])

          simple_array.each { |v| csv << [v] }
        end
      end

      if simple_hashes_array.present?
        csv_file = base_dir + sanitize_filename("#{name}_b.csv")
        headers  = simple_hashes_array.map { |v| v.keys }.flatten.uniq

        ::CSV.open(csv_file, 'w', CSV_OPTIONS) do |csv|
          csv << with_utf_bomb(headers)

          simple_hashes_array.each do |hash|
            row = []

            headers.each { |header| row << hash[header] }

            csv << row
          end
        end
      end

      compound_array.each_with_index do |v, i|
        if v.kind_of? Hash
          hash_to_csv  base_dir, [name, i + 1].join('.'), v
        elsif
          array_to_csv base_dir, [name, i + 1].join('.'), v
        end
      end
    end

    def sanitize_filename filename
      splited_name = filename[0, 200].split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

      splited_name.map { |s| s.gsub /[^a-z0-9\-]+/i, '_' }.join '.'
    end

    def zip_dir_content base_dir
      entries = Dir.entries(base_dir) - %w(. ..)
      file    = "#{EXPORTS_PATH}/#{SecureRandom.uuid}.zip"

      ::Zip::File.open file, ::Zip::File::CREATE do |zipfile|
        entries.each { |entry| zipfile.add entry, base_dir + entry }
      end

      base_dir.rmtree

      file
    end

    def with_utf_bomb array
      array.each_with_index.map do |element, i|
        i == 0 ? "\uFEFF#{element}" : element
      end
    end
end

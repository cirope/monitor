# frozen_string_literal: true

module Issues::Export
  extend ActiveSupport::Concern

  CSV_OPTIONS = { col_sep: ';' }

  def export_data
    ZipUtils.tmp_file_content export_to_csvs if data.present?
  end

  def export_filename
    sanitize_filename "#{description}.zip"
  end

  private

    def export_to_csvs
      @files_content = {}

      if data.kind_of? Hash
        hash_to_csv  description, data
      elsif data.kind_of? Array
        array_to_csv description, data
      end

      @files_content
    end

    def hash_to_csv name, hash
      compound_hash, simple_hash = *hash.partition do |k, v|
        v.kind_of?(Array) || v.kind_of?(Hash)
      end

      if simple_hash.present?
        csv_content name do |csv|
          _hash = simple_hash.to_h

          csv << with_utf_bomb(_hash.keys)
          csv << _hash.values
        end
      end

      compound_hash.each do |k, v|
        if v.kind_of? Hash
          hash_to_csv  [name, k].join('.'), v
        else
          array_to_csv [name, k].join('.'), v
        end
      end
    end

    def array_to_csv name, array
      compound_array, simple_array = *array.partition do |v|
        v.kind_of?(Array) || v.kind_of?(Hash)
      end
      simple_hashes_array, compound_array = *compound_array.partition do |v|
        v.kind_of?(Hash) && v.values.all? { |hv| !hv.kind_of?(Array) && !hv.kind_of?(Hash) }
      end

      if simple_array.present?
        csv_content name do |csv|
          csv << with_utf_bomb([name])

          simple_array.each { |v| csv << [v] }
        end
      end

      if simple_hashes_array.present?
        csv_content name do |csv|
          headers  = simple_hashes_array.map { |v| v.keys }.flatten.uniq

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
          hash_to_csv  [name, i + 1].join('.'), v
        elsif
          array_to_csv [name, i + 1].join('.'), v
        end
      end
    end

    def sanitize_filename filename
      splited_name = filename[0, 200].split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

      splited_name.map { |s| s.gsub /[^a-z0-9\-]+/i, '_' }.join '.'
    end

    def with_utf_bomb array
      array.each_with_index.map do |element, i|
        i == 0 ? "\uFEFF#{element}" : element
      end
    end

    def csv_content name
      key = sanitize_filename(name) + '.csv'

      # Ensure no-collision
      if @files_content.key?(key)
        @basename_index ||= 0
        key = sanitize_filename(name + " #{@basename_index += 1}") + '.csv'
      end

      @files_content[key] = ::CSV.generate(CSV_OPTIONS) do |csv|
        yield csv
      end
    end
end

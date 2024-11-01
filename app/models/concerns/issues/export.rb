# frozen_string_literal: true

module Issues::Export
  extend ActiveSupport::Concern

  CSV_OPTIONS = { col_sep: ';' }

  def export_content
    self.class.tmp_zip_file_content export_to_csvs if data.present?
  end

  def export_filename
    sanitize_filename "#{description || model_name.human}.zip"
  end

  def export_attachments
    export_to_csvs
  end

  private

    def export_to_csvs
      @files_content = {}
      data           = canonical_data
      filename       = description || model_name.human

      if data.kind_of? Hash
        hash_to_csv  filename, data
      elsif data.kind_of? Array
        array_to_csv filename, data
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
        send(
          v.kind_of?(Hash) ? :hash_to_csv : :array_to_csv,
          [name, k].join('.'), v
        )
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
            csv << headers.map { |header| hash[header] }
          end
        end
      end

      compound_array.each do |v|
        send(
          v.kind_of?(Hash) ? :hash_to_csv : :array_to_csv,
          name, v
        )
      end
    end

    def sanitize_filename filename
      splited_name = filename[0, 200].split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

      splited_name.map { |s| s.gsub /[^a-z0-9\-\_\.]+/i, '_' }.join '.'
    end

    def with_utf_bomb array
      array.each_with_index.map do |element, i|
        i == 0 ? "\uFEFF#{element}" : element
      end
    end

    def csv_content name
      key = sanitize_filename(name) + '.csv'

      # Ensure no-collision
      if @files_content.key? key
        @basenames_index ||= {}
        @basenames_index[name] ||= 0
        key = sanitize_filename(name + "_#{@basenames_index[name] += 1}") + '.csv'
      end

      @files_content[key] = ::CSV.generate **CSV_OPTIONS do |csv|
        yield csv
      end
    end
end

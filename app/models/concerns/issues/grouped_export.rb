# frozen_string_literal: true

module Issues::GroupedExport
  extend ActiveSupport::Concern

  CSV_OPTIONS       = { col_sep: ';' }
  HEADERS_SEPARATOR = '⁻-⁻'

  module ClassMethods
    def grouped_export
      csvs_by_script = {}
      grouped_ids    = ids_grouped_by_script_id
      scripts        = Script.where(id: grouped_ids.keys).pluck(:id, :name).to_h

      grouped_ids.each do |script_id, issue_ids|
        acc         = {}
        script_name = scripts[script_id]

        summarized_find_each_for_ids issue_ids do |issue|
          issue.grouped_export script_name, acc
        end

        grouped_csvs = build_csvs_for_groups acc
        filename     = "#{sanitize_filename script_name}.zip"

        csvs_by_script[filename] = tmp_zip_file_content grouped_csvs
      end

      hash_to_zip csvs_by_script
    end

    private

      def summarized_find_each_for_ids ids
        Issue.where(id: ids).select(:id, :description, :data).find_each(batch_size: 100) do |issue|
          yield issue
        end
      end

      def ids_grouped_by_script_id
        scripts_with_issues = {}
        select_columns      = ["#{Issue.table_name}.id", "#{Job.table_name}.script_id"]

        all.joins(run: :job).pluck(*select_columns).each do |issue_id, script_id|
          scripts_with_issues[script_id] ||= []
          scripts_with_issues[script_id] << issue_id
        end

        scripts_with_issues
      end

      def build_csvs_for_groups groups
        csvs = {}

        groups.each do |name_with_headers, rows|
          name, *headers = name_with_headers.split HEADERS_SEPARATOR
          filename       = grouped_sanitized_filename name, csvs

          csvs[filename] = CSV.generate CSV_OPTIONS do |csv|
            csv << headers

            rows.each { |row| csv << row}
          end
        end

        csvs
      end

      def sanitize_filename filename
        splited_name = filename[0, 200].split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

        splited_name.map { |s| s.gsub /[^a-z0-9\-\_\.]+/i, '_' }.join '.'
      end

      def grouped_sanitized_filename name, csvs
        filename = sanitize_filename name

        # Ensure no-collision
        if csvs.key? "#{filename}.csv"
          @basename_indexes       ||= {}
          @basename_indexes[name] ||= 0

          filename += "_#{@basename_indexes[name] += 1}"
        end

        "#{filename}.csv"
      end
  end

  def grouped_export name = description, group = {}
    data = converted_data

    if data.kind_of? Hash
      group_hash_to_csv  name, data, group
    elsif data.kind_of? Array
      group_array_to_csv name, data, group
    end

    group
  end

  private

    def group_hash_to_csv name, hash, group
      array_or_hash, nested_hash = *hash.partition do |k, v|
        v.kind_of?(Array) || v.kind_of?(Hash)
      end

      if nested_hash.present?
        simple_hash       = nested_hash.to_h
        name_with_headers = group_name_with_headers name, simple_hash.keys

        group[name_with_headers] ||= []
        group[name_with_headers]  << [description] + simple_hash.values
      end

      array_or_hash.each { |k, v| group_by_kind_to_csv [name, k].join('.'), v, group }
    end

    def group_array_to_csv name, array, group
      compound_array, simple_array = *array.partition do |v|
        v.kind_of?(Array) || v.kind_of?(Hash)
      end
      simple_hashes_array, compound_array = *compound_array.partition do |v|
        v.kind_of?(Hash) && v.values.all? { |hv| !hv.kind_of?(Array) && !hv.kind_of?(Hash) }
      end

      group_simple_array name, simple_array, group if simple_array.present?
      group_simple_hashes_array name, simple_hashes_array, group if simple_hashes_array.present?

      compound_array.each { |v| group_by_kind_to_csv name, v, group }
    end

    def group_simple_array name, simple_array, group
      name_with_headers          = group_name_with_headers "#{name}.simple", name
      group[name_with_headers] ||= []

      simple_array.each { |v| group[name_with_headers] << [description, v] }
    end

    def group_simple_hashes_array name, simple_hashes_array, group
      headers                    = simple_hashes_array.map(&:keys).flatten.uniq
      name_with_headers          = group_name_with_headers name, headers
      group[name_with_headers] ||= []

      simple_hashes_array.each do |hash|
        group[name_with_headers] << [description] + headers.map { |header| hash[header] }
      end
    end

    def group_name_with_headers name, headers
      [
        name, "\uFEFF#{Issue.human_attribute_name :description}", headers
      ].flatten.join HEADERS_SEPARATOR
    end

    def group_by_kind_to_csv name, array_or_hash, group
      send(
        array_or_hash.kind_of?(Hash) ? :group_hash_to_csv : :group_array_to_csv,
        name, array_or_hash, group
      )
    end
end

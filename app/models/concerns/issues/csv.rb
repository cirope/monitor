# frozen_string_literal: true

module Issues::Csv
  extend ActiveSupport::Concern

  module ClassMethods
    def csv_name
      model_name.human count: 0
    end

    def to_csv
      file    = "#{export_path}/#{SecureRandom.uuid}.csv"
      headers = csv_headers
      rows    = csv_rows

      result = CSV.generate col_sep: ';' do |csv|
        csv << csv_headers

        csv_rows.each { |row| csv << row}
      end

      File.open(file, 'w') { |f| f << "\uFEFF#{result}" }

      file
    end

    def can_collapse_data?
      issues.all?(&:display_row_data_type?) ||
        (issues.any? && issues.all?(&:single_row_data_type?) && issues_can_share_headers?)
    end

    private

      def issues_can_share_headers?
        header_rows = issues.map(&:converted_data).map &:first

        if header_rows.all? { |row| row.kind_of?(Hash) }
          sample = header_rows.first.keys.sort

          header_rows.all? { |row| row.keys.sort == sample }
        end
      end


      def csv_headers
        if can_collapse_data?
          headers = first.converted_data.first.keys

          [
            Issue.human_attribute_name('description'),
            headers[0...-1],
            Issue.human_attribute_name('status'),
            headers.last
          ].compact.flatten
        else
          [
            Run.human_attribute_name('scheduled_at'),
            Issue.human_attribute_name('created_at'),
            Issue.human_attribute_name('description'),
            Issue.human_attribute_name('status'),
            Tag.model_name.human(count: 0)
          ]
        end
      end

      def csv_rows
        issues_rows = issues.order(:created_at).preload :run, :tags

        if can_collapse_data?
          issues_rows.map do |issue|
            data = issue.converted_data.first.values

            [
              issue.description,
              data[0...-1],
              I18n.t("issues.status.#{issue.status}"),
              data.last
            ].compact.flatten
          end
        else
          issues_rows.map do |issue|
            [
              I18n.l(issue.run.scheduled_at, format: :compact),
              I18n.l(issue.created_at, format: :compact),
              issue.description,
              I18n.t("issues.status.#{issue.status}"),
              issue.tags.to_sentence
            ]
          end
        end
      end
  end
end

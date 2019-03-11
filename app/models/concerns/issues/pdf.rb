# frozen_string_literal: true

module Issues::PDF
  extend ActiveSupport::Concern

  module ClassMethods
    def pdf_name
      model_name.human count: 0
    end

    def to_pdf
      file = "#{EXPORTS_PATH}/#{SecureRandom.uuid}.pdf"
      pdf  = Prawn::Document.new

      pdf.fill_color = '222222'

      pdf.text I18n.t('issues.pdf.title'), size: 16
      pdf.move_down 6

      put_names_on             pdf
      put_users_on             pdf
      put_issues_by_month_on   pdf
      put_summary_by_script_on pdf
      put_issue_details_on     pdf
      put_footer_on            pdf

      pdf.render_file file

      file
    end

    private

      def put_names_on pdf
        grouped_issues = grouped_by_script.ordered_by_script_name.count

        grouped_issues.each do |script_data, count|
          script_id, script_name = *script_data

          script            = Script.find script_id
          issue_count_label = I18n.t('issues.pdf.issue', count: count)

          pdf.text "#{script} (#{issue_count_label})", style: :bold

          put_script_descriptions_on pdf, script

          pdf.move_down 12
        end
      end

      def put_users_on pdf
        if users.any?
          pdf.text User.model_name.human(count: 0), size: 16
          pdf.move_down 6

          pdf.indent 16 do
            pdf.text to_list(users)
          end

          pdf.move_down 12
        end
      end

      def put_issues_by_month_on pdf
        data           = [issues_by_month_headers]
        grouped_issues = includes(:script).group_by do |issue|
          issue.created_at.beginning_of_month
        end

        pdf.text I18n.t('issues.pdf.by_month'), size: 16
        pdf.move_down 6

        grouped_issues.each do |month, issues|
          issues_data = data.clone

          issues.group_by(&:script).each do |script, issues|
            issues_data << [script.to_s, issues.size, issue_tag_list(issues)]
          end

          pdf.text I18n.l(month, format: '%B %Y').camelize
          pdf.move_down 6

          pdf.indent 16 do
            put_table_on pdf, issues_data, column_widths: [254, 70, 200]
          end

          pdf.move_down 12
        end
      end

      def put_summary_by_script_on pdf
        data   = [issues_summary_headers]
        counts = grouped_by_script.ordered_by_script_name.group(:status).count

        pdf.text I18n.t('issues.pdf.summary'), size: 16
        pdf.move_down 6

        counts.each do |script_data, count|
          script_id, script_name, status = *script_data
          issues = joins(:script).where(status: status, scripts: { id: script_id })

          data << [
            script_name,
            I18n.t("issues.status.#{status}"),
            count,
            issue_tag_list(issues)
          ]
        end

        put_table_on pdf, data, column_widths: [210, 60, 70, 200]
        pdf.move_down 12
      end

      def put_issue_details_on pdf
        issues = includes :script, :tags
        data   = [issues_details_headers]

        pdf.text I18n.t('issues.pdf.details'), size: 16
        pdf.move_down 6

        issues.ordered_by_script_name.order(:created_at).each do |issue|
          last_comment = issue.last_comment

          data << [
            issue.script.to_s,
            I18n.l(issue.created_at, format: :compact),
            issue.description,
            I18n.t("issues.status.#{issue.status}"),
            to_list(issue.tags),
            [last_comment&.user.to_s, last_comment&.text].compact.join(': ')
          ]
        end

        put_table_on pdf, data, column_widths: { 3 => 50, 4 => 60 }
        pdf.move_down 6
      end

      def put_footer_on pdf
        footer  = '<page> / <total>'
        options = { at: [pdf.bounds.right - 150, 0], align: :right, size: 9 }

        pdf.number_pages footer, options
      end

      def put_script_descriptions_on pdf, script
        if script.descriptions.any?
          data = [description_headers]

          script.descriptions.each do |description|
            data << [description.name, description.value]
          end

          pdf.indent 16 do
            pdf.move_down 6
            pdf.text Description.model_name.human(count: script.descriptions.size)
            pdf.move_down 6

            put_table_on pdf, data
          end
        end
      end

      def description_headers
        [
          Description.human_attribute_name('name'),
          Description.human_attribute_name('value')
        ]
      end

      def issues_by_month_headers
        [
          Issue.model_name.human(count: 1),
          I18n.t('issues.pdf.issue.count'),
          Tag.model_name.human(count: 0)
        ]
      end

      def issues_summary_headers
        [
          Issue.model_name.human(count: 1),
          Issue.human_attribute_name('status'),
          I18n.t('issues.pdf.issue.count'),
          Tag.model_name.human(count: 0)
        ]
      end

      def issues_details_headers
        [
          Script.model_name.human(count: 1),
          Issue.human_attribute_name('created_at'),
          Issue.human_attribute_name('description'),
          Issue.human_attribute_name('status'),
          Tag.model_name.human(count: 0),
          I18n.t('issues.pdf.issue.last_comment')
        ]
      end

      def users
        User.by_issues(all).by_role(%w(author supervisor)).reorder :lastname
      end

      def issue_tag_list issues
        issues_relation  = convert_to_relation issues
        not_tagged_count = issues_relation.not_tagged.count

        tag_names_as_list tag_names_for(issues_relation), not_tagged_count
      end

      def tag_names_for issues
        Tag.by_issues(issues).reorder(:name).group(:name).count "#{Issue.table_name}.id"
      end

      def tag_names_as_list tag_names, not_tagged_count
        list = []

        tag_names.each do |name, count|
          list << "#{name} (#{count})"
        end

        if not_tagged_count > 0
          list << "#{I18n.t('issues.pdf.issue.not_tagged')} (#{not_tagged_count})"
        end

        to_list list
      end

      def convert_to_relation issues
        if issues.kind_of? ActiveRecord::Relation
          issues
        else
          Issue.where id: issues.map(&:id)
        end
      end

      def to_list list
        list.map { |item| "• #{item}" }.join("\n")
      end

      def put_table_on pdf, data, options = {}
        default_options = {
          header: true,
          width:  pdf.bounds.width,
          cell_style: {
            size: 8
          }
        }

        pdf.table data, default_options.merge(options) do
          cells.border_width      = 0.5
          cells.border_color      = '222222'
          row(0).font_style       = :bold
          row(0).background_color = 'f5f5f5'
        end
      end
  end
end

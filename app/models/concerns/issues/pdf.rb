module Issues::Pdf
  extend ActiveSupport::Concern

  module ClassMethods
    def pdf_name
      model_name.human count: 0
    end

    def to_pdf
      file = "#{EXPORTS_PATH}/#{SecureRandom.uuid}.pdf"
      pdf  = Prawn::Document.new

      pdf.text I18n.t('issues.pdf.title'), size: 16, style: :bold
      pdf.move_down 16

      put_names_on             pdf
      put_users_on             pdf
      put_issues_by_month_on   pdf
      put_summary_by_script_on pdf
      put_issue_details_on     pdf

      pdf.render_file file

      file
    end

    private

      def put_names_on pdf
        grouped_by_script.ordered_by_script_name.count.each do |script_data, count|
          script_id, script_name = *script_data
          script                 = Script.find script_id
          issue_count_label      = I18n.t('issues.pdf.issue', count: count)

          pdf.text "• #{script} (#{issue_count_label})", style: :bold

          put_script_descriptions_on pdf, script

          pdf.move_down 12
        end
      end

      def put_users_on pdf
      end

      def put_issues_by_month_on pdf
      end

      def put_summary_by_script_on pdf
      end

      def put_issue_details_on pdf
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

      def put_table_on pdf, data
        options = {
          header: true,
          width:  pdf.bounds.width,
          cell_style: {
            size: 9
          }
        }

        pdf.table data, options do
          cells.border_width = 0.5
          row(0).font_style  = :bold
        end
      end
  end
end

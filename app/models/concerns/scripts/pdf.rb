module Scripts::Pdf
  extend ActiveSupport::Concern

  def to_pdf
    file = "#{EXPORTS_PATH}/#{SecureRandom.uuid}.pdf"
    pdf  = Prawn::Document.new

    pdf.text name

    put_text_on   pdf
    put_data_on   pdf
    put_footer_on pdf

    pdf.render_file file

    file
  end

  private

    def put_text_on pdf
      put_hr_on pdf

      pdf.font 'Courier', size: 9.5 do
        tokens = CodeRay.scan(text, :ruby).to_prawn.map do |token|
          token[:text] = token[:text].gsub ' ', Prawn::Text::NBSP

          token
        end

        pdf.formatted_text tokens
      end

      put_hr_on pdf
    end

    def put_hr_on pdf
      pdf.line_width = 0.5
      pdf.dash = [2, 1]

      pdf.move_down 10
      pdf.stroke_horizontal_rule
      pdf.move_down 10

      pdf.line_width = 1
      pdf.undash
    end

    def put_data_on pdf
      if parameters.any?
        data = [parameter_headers]

        parameters.each { |parameter| data << [parameter.name, parameter.value] }

        pdf.move_down 10
        pdf.text Parameter.model_name.human(count: parameters.size), style: :bold
        pdf.move_down 10

        put_table_on pdf, data
      end
    end

    def put_footer_on pdf
      footer = "#{I18n.l Time.zone.now, format: :compact} (<page> / <total>)"

      pdf.number_pages footer, at: [pdf.bounds.right - 150, 0], align: :right
    end

    def put_table_on pdf, data
      options = {
        header: true,
        width: pdf.bounds.width,
        cell_style: {
          size: 9
        }
      }

      pdf.table data, options do
        cells.border_width = 0.5
        row(0).font_style  = :bold
      end
    end

    def parameter_headers
      [
        Parameter.human_attribute_name('name'),
        Parameter.human_attribute_name('value')
      ]
    end
end

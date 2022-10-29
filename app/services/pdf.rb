# frozen_string_literal: true

class Pdf
  def self.generate content_html, locals: {}, options: {}
    pdf_html =
      ActionController::Base.new.render_to_string inline: content_html,
                                                  locals: locals,
                                                  layout: 'pdf'

    WickedPdf.new.pdf_from_string pdf_html, options
  end

  def self.generate_from_template template_name, locals: {}, options: {}
    pdf_template = PdfTemplate.find_by! name: template_name

    pdf_html =
      ActionController::Base.new.render_to_string inline: pdf_template.content
                                                                      .body
                                                                      .to_trix_html
                                                                      .gsub('<pre>', '<%= ')
                                                                      .gsub('</pre>', ' %>'),
                                                  locals: locals,
                                                  layout: 'pdf'

    WickedPdf.new.pdf_from_string pdf_html, options
  end
end

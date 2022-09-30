# frozen_string_literal: true

class GeneratorPdf
  def self.generate content_html, options = {}
    pdf_html =
      ActionController::Base.new
                            .render_to_string options.merge(inline: content_html, layout: 'pdf')

    WickedPdf.new.pdf_from_string(pdf_html)
  end
end

# frozen_string_literal: true

class GeneratorPdf
  def self.generate content_html, locals = {}, options = {}
    pdf_html =
      ActionController::Base.new.render_to_string inline: content_html,
                                                  locals: locals,
                                                  layout: 'pdf'

    WickedPdf.new.pdf_from_string pdf_html, options
  end
end

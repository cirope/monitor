# frozen_string_literal: true

module PdfRender
  extend ActiveSupport::Concern

  def render_pdf object
    path     = object.to_pdf
    filename = object.respond_to?(:pdf_name) ? object.pdf_name : object.to_s
    response = send_file path,
                         type:        :pdf,
                         filename:    "#{filename}.pdf",
                         disposition: 'attachment'

    FileRemoveJob.set(wait: 15.minutes).perform_later path

    response
  end
end

ActionController::Renderers.add :pdf do |object, options|
  path     = object.to_pdf
  response = send_file path,
    type:        :pdf,
    disposition: "attachment; filename=#{object}.pdf"

  FileRemoveJob.set(wait: 15.minutes).perform_later path

  response
end

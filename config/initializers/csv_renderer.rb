# frozen_string_literal: true

ActionController::Renderers.add :csv do |object, options|
  path     = object.to_csv
  filename = object.respond_to?(:csv_name) ? object.csv_name : object.to_s
  response = send_file path,
    type:        :csv,
    filename:    "#{filename}.csv",
    disposition: 'attachment'

  FileRemoveJob.set(wait: 15.minutes).perform_later path

  response
end

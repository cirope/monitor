class Scripts::ExportsController < ApplicationController
  before_action :authorize, :not_guest, :not_security

  def create
    path = Script.for_export.export
    mime = Mime::Type.lookup_by_extension 'zip'

    send_file path, type: mime, filename: t('.filename')

    FileRemoveJob.set(wait: 15.minutes).perform_later path
  end
end

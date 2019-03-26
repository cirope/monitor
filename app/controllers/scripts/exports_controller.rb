# frozen_string_literal: true

class Scripts::ExportsController < ApplicationController
  before_action :authorize, :not_guest, :not_security

  def create
    path = scripts.export
    mime = Mime::Type.lookup_by_extension 'zip'

    set_file_download_headers path
    send_file path, type: mime, filename: t('.filename')

    FileRemoveJob.set(wait: 15.minutes).perform_later path
  end

  private

    def scripts
      if params[:id]
        Script.where id: params[:id]
      else
        Script.for_export
      end
    end
end

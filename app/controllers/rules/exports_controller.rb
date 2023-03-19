# frozen_string_literal: true

class Rules::ExportsController < ApplicationController
  include Authentication
  include Authorization

  def create
    path = rules.export
    mime = Mime::Type.lookup_by_extension 'zip'

    set_file_download_headers path
    send_file path, type: mime, filename: t('.filename')

    FileRemoveJob.set(wait: 15.minutes).perform_later path
  end

  private

    def rules
      if params[:id]
        Rule.where id: params[:id]
      else
        Rule.all
      end
    end
end

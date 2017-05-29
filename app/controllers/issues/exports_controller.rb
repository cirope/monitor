class Issues::ExportsController < ApplicationController
  include Issues::Filters

  before_action :authorize, :set_issues

  def create
    path = @issues.export_data
    mime = Mime::Type.lookup_by_extension 'zip'

    set_file_download_headers path
    send_file path, type: mime, filename: t('.filename')

    FileRemoveJob.set(wait: 15.minutes).perform_later path
  end

  private

    def set_issues
      @issues = issues.where id: params[:ids]
    end
end

# frozen_string_literal: true

class Issues::ExportsController < ApplicationController
  include Authorization
  include Issues::Filters

  before_action :set_issues

  def create
    path = export_path
    mime = Mime::Type.lookup_by_extension 'zip'

    set_file_download_headers path
    send_file path, type: mime, filename: t('.filename')

    FileRemoveJob.set(wait: 15.minutes).perform_later path
  end

  private

    def set_issues
      @issues = issues.where id: params[:ids] || board_issues
    end

    def board_issues
      session[:board_issues] ||= []
    end

    def export_path
      params[:grouped] ? @issues.grouped_export : @issues.export
    end
end

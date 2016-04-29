class FilesController < ApplicationController
  before_action :authorize

  def show
    file = (Rails.root + "private/#{params[:path]}").expand_path

    if safe_file_path? file
      mime_type = Mime::Type.lookup_by_extension File.extname(file)[1..-1]

      response.headers['Last-Modified'] = File.mtime(file).httpdate
      response.headers['Cache-Control'] = 'private, no-store'

      send_file file, type: mime_type || 'application/octet-stream'
    else
      redirect_to root_url, notice: t('messages.file_not_found')
    end
  end

  private

    def safe_file_path? file
      file.exist? && file.file? && file.to_s.start_with?("#{Rails.root}/private")
    end
end

module CacheControl
  extend ActiveSupport::Concern

  included do
    attr_accessor :downloading_file

    after_action :set_cache_control, unless: :downloading_file
  end

  def set_file_download_headers file_path
    self.downloading_file = true

    response.headers['Last-Modified'] = File.mtime(file_path).httpdate
    response.headers['Cache-Control'] = 'private, no-store'
  end

  private

    def set_cache_control
      if current_user
        response.headers['Pragma']        = 'no-cache'
        response.headers['Expires']       = 'Fri, 01 Jan 1990 00:00:00 GMT'
        response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
      end
    end
end

module StoreLocation
  extend ActiveSupport::Concern

  included do
    before_action :store_location, unless: :current_user
  end

  def store_location
    session[:previous_url] = request.fullpath unless exclude_from_store?
  end

  private

    def exclude_from_store?
      !request.get? || !request.format.html? || request.xhr? || excluded_path?
    end

    def excluded_path?
      excluded_paths = [
        /^\/$/,
        /^\/login.*$/,
        /^\/password_resets\/new.*$/,
        /^\/password_resets\/.*\/edit.*$/,
        /^\/accounts\/.*\/password_resets\/.*\/edit.*$/
      ]

      excluded_paths.any? { |path| request.fullpath =~ path }
    end
end

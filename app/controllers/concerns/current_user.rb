module CurrentUser
  extend ActiveSupport::Concern

  included do
    puts self
    (helper_method :current_user) rescue nil
  end

  def current_user
    @current_user ||= user_by_auth_token if cookies.encrypted[:auth_token]
  end

  private

    def user_by_auth_token
      User.find_by auth_token: cookies.encrypted[:auth_token]
    end
end

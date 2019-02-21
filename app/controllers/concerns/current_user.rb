module CurrentUser
  extend ActiveSupport::Concern

  included do
    helper_method :current_user if respond_to? :helper_method
  end

  def current_user
    @current_user ||= user_by_auth_token if cookies.encrypted[:token]
  end

  private

    def user_by_auth_token
      Current.user = User.find_by auth_token: cookies.encrypted[:token]
    end
end

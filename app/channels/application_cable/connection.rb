module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include CurrentUser
    # identified_by :current_user

    def connect
      byebug
      # self.current_user = find_verified_user
    end

    private

    # def find_verified_user
    #   @current_user ||= User.find_by auth_token: cookies.encrypted[:auth_token]
    #   @current_user || reject_unauthorized_connection
    # end
  end
end

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include CurrentUser

    def connect
      current_user || reject_unauthorized_connection
    end
  end
end

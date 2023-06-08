module Runs::Notifications
  extend ActiveSupport::Concern

  def notify_users
    users.distinct.find_each { |user| user.notify_issues issues }
  end
end

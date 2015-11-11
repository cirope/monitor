module Issues::Notifications
  extend ActiveSupport::Concern

  def notify_to recipients
    Notifier.issue(self, recipients).deliver_later
  end
end

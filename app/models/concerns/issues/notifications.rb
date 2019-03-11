# frozen_string_literal: true

module Issues::Notifications
  extend ActiveSupport::Concern

  def notify_to recipients
    Notifier.issue(self, recipients).deliver_later wait: 5.seconds
  end
end

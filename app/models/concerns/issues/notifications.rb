# frozen_string_literal: true

module Issues::Notifications
  extend ActiveSupport::Concern

  def notify_to recipients, data_as_csv: false
    Notifier.issue(self, recipients, data_as_csv: data_as_csv).deliver_later wait: 5.seconds
  end
end

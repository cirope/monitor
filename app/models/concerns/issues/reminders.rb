# frozen_string_literal: true

module Issues::Reminders
  extend ActiveSupport::Concern

  included do
    has_many :reminders, dependent: :destroy

    after_update :check_status_changed_reminders
  end

  def notify_reminders
    reminders.each(&:notify)
  end

  private

    def check_status_changed_reminders
      if status_changed?
        reminders.each { |r| r.new_issue_status status }
      end
    end
end

# frozen_string_literal: true

module Issues::Reminders
  extend ActiveSupport::Concern

  included do
    has_many :reminders, dependent: :destroy

    after_update :check_issue_status_changed_reminders
  end

  private

    def check_issue_status_changed_reminders
      if status_was != status
        reminders.each { |r| r.new_status_issue status}
      end
    end
end

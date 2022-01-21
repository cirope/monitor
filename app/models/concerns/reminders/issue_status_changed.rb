# frozen_string_literal: true

module Reminders::IssueStatusChanged
  extend ActiveSupport::Concern

  def new_status_issue new_status
    if should_change_state?
      self.state_class_type = issue_status_changed[new_status]
    end
  end

  private

    def should_change_state?
      issue_status_changed[new_status].present? && states.include(issue_status_changed[new_status])
    end
end

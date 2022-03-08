# frozen_string_literal: true

module Reminders::TransitionRules
  extend ActiveSupport::Concern

  def new_issue_status new_status
    if should_change_state? new_status
      self.state_class_type = transition_rules['status_changed'][new_status]
    end
  end

  private

    def should_change_state? new_status
      Reminders::States::STATUSES.include?(Hash(transition_rules).dig('status_changed', new_status))
    end
end

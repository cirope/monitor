# frozen_string_literal: true

class Reminder < ApplicationRecord
  include Reminders::Execution
  include Reminders::Notifications
  include Reminders::Scopes
  include Reminders::States
  include Reminders::TransitionRules
  include Reminders::Validation

  belongs_to :issue
end

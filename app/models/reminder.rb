# frozen_string_literal: true

class Reminder < ApplicationRecord
  include Reminders::States
  include Reminders::Validation

  belongs_to :issue
end

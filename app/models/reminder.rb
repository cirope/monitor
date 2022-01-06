# frozen_string_literal: true

class Reminder < ApplicationRecord
  include Reminders::Status

  belongs_to :issue
end

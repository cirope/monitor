# frozen_string_literal: true

module Reminders::Status
  extend ActiveSupport::Concern

  included do
    enum status: {
      canceled:  'canceled',
      pending:   'pending',
      done:      'done'
    }
  end
end

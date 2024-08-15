# frozen_string_literal: true

module Reminders::Notifications
  extend ActiveSupport::Concern

  def notify
    state.notify self
  end
end

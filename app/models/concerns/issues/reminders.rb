# frozen_string_literal: true

module Issues::Reminders
  extend ActiveSupport::Concern

  included do
    has_many :reminders, dependent: :destroy

    before_save :cancel_reminders_if_closed
  end

  def cancel_reminders_if_closed
    reminders.each { |r| r.status = 'closed' } if closed? 
  end
end

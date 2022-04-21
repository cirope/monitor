# frozen_string_literal: true

module Issues::Reminders
  extend ActiveSupport::Concern

  included do
    has_many :reminders, dependent: :destroy

    before_save :check_status_changed_reminders
  end

  private

    def check_status_changed_reminders
      if status_changed?
        reminders.each do |r|
          r.new_issue_status status
          r.save!
        end
      end
    end
end

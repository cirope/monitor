# frozen_string_literal: true

class ReminderMailer < ApplicationMailer
  def reminder_issue reminder
    @reminder = reminder
    emails    = reminder.issue.users.by_role('manager').collect(&:email).join(',')

    mail to: emails
  end
end

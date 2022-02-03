# frozen_string_literal: true

class ReminderMailer < ApplicationMailer
  def reminder_issue reminder, user
    @reminder = reminder
    @user     = user

    mail to: user.email
  end
end

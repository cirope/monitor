# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/reminder_mailer/reminder_issue
  def reminder_issue
    user     = User.new(email: 'test@test.com', name: 'test')
    issue    = Issue.new(id: 1, description: 'description', users: [user])
    reminder = Reminder.new(issue: issue)

    ReminderMailer.reminder_issue reminder, user
  end
end

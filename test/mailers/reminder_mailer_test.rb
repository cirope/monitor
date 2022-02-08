# frozen_string_literal: true

require 'test_helper'

class ReminderMailerTest < ActionMailer::TestCase
  test 'reminder_issue' do
    reminder   = reminders(:reminder_of_ls_on_atahualpa_not_well)
    issue_user = reminder.issue.users.first
    mail       = ReminderMailer.reminder_issue(reminder, issue_user)
    url        = Rails.application
                      .routes
                      .url_helpers
                      .issue_url(reminder.issue, host: ENV['APP_HOST'], protocol: ENV['APP_PROTOCOL'])

    assert_equal I18n.t('reminder_mailer.reminder_issue.subject'), mail.subject
    assert_equal [issue_user.email], mail.to
    assert_equal [ENV['EMAIL_ADDRESS']], mail.from
    assert_match issue_user.name, mail.html_part.body.decoded
    assert_match reminder.issue.description, mail.html_part.body.decoded
    assert_match url, mail.html_part.body.decoded
    assert_match issue_user.name, mail.text_part.body.decoded
    assert_match reminder.issue.description, mail.text_part.body.decoded
    assert_match url, mail.text_part.body.decoded
  end
end

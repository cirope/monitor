# frozen_string_literal: true

require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test 'notify' do
    path    = File.join Rails.root, 'test', 'fixtures', 'files', 'test.sh'
    file    = File.read path
    message = {
      to:          'test@monitor.com',
      body:        'Test message',
      attachments: {
        'test.sh': file
      }
    }
    mail    = Notifier.notify message

    assert_equal I18n.t('notifier.notify.subject'), mail.subject
    assert_equal [message[:to]], mail.to
    assert_equal [ENV['EMAIL_ADDRESS']], mail.from
    assert_equal 1, mail.attachments.size
    assert_match mail.attachments.first.filename, message[:attachments].keys.first
    assert_match message[:body], mail.html_part.body.decoded
    assert_match message[:body], mail.text_part.body.decoded
  end

  test 'issue' do
    issue = issues :ls_on_atahualpa_not_well
    mail  = Notifier.issue issue, 'test@monitor.com'

    assert_equal I18n.t('notifier.issue.subject'), mail.subject
    assert_equal ['test@monitor.com'], mail.to
    assert_equal [ENV['EMAIL_ADDRESS']], mail.from
    assert_match issue.description, mail.html_part.body.decoded
    assert_match issue.description, mail.text_part.body.decoded
  end

  test 'comment' do
    comment = comments :possitive
    mail    = Notifier.comment comment, comment.users

    assert_equal I18n.t('notifier.comment.subject'), mail.subject
    assert_equal comment.users.pluck('email'), mail.to
    assert_equal [ENV['EMAIL_ADDRESS']], mail.from
    assert_match comment.text, mail.html_part.body.decoded
    assert_match comment.text, mail.text_part.body.decoded
  end

  test 'mass comment' do
    comment   = comments :possitive
    user      = users :franco
    permalink = permalinks :link
    mail      = Notifier.mass_comment user:      user,
                                      comment:   comment,
                                      permalink: permalink

    assert_equal I18n.t('notifier.mass_comment.subject'), mail.subject
    assert_equal [user.email], mail.to
    assert_equal [ENV['EMAIL_ADDRESS']], mail.from
    assert_match comment.text, mail.html_part.body.decoded
    assert_match comment.text, mail.text_part.body.decoded
  end
end

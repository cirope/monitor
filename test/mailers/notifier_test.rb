require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test 'notify' do
    message = { to: 'test@monitor.com', body: 'Test message' }
    mail    = Notifier.notify message

    assert_equal I18n.t('notifier.notify.subject'), mail.subject
    assert_equal [message[:to]], mail.to
    assert_equal [ENV['EMAIL_ADDRESS']], mail.from
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
end

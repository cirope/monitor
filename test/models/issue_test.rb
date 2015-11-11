require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  def setup
    @issue = issues :ls_on_atahualpa_not_well
  end

  test 'blank attributes' do
    @issue.status = ''

    assert @issue.invalid?
    assert_error @issue, :status, :blank
  end

  test 'included attributes' do
    @issue.status = 'wrong'

    assert @issue.invalid?
    assert_error @issue, :status, :inclusion
  end

  test 'next status' do
    @issue.status = 'pending'
    assert_equal %w(pending taken closed), @issue.next_status

    @issue.status = 'taken'
    assert_equal %w(taken closed), @issue.next_status

    @issue.status = 'closed'
    assert_equal %w(closed), @issue.next_status
  end

  test 'notify to' do
    assert_emails 1 do
      @issue.notify_to 'test@monitor.com'
    end
  end
end

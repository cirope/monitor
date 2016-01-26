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

  test 'tagged with' do
    tag    = tags :important
    issues = Issue.tagged_with tag.name

    assert_not_equal 0, issues.count
    assert_not_equal 0, issues.take.tags.count
    assert issues.all? { |issue| issue.tags.any? { |t| t.name == tag.name } }
  end

  test 'pending?' do
    assert @issue.pending?

    @issue.status = 'taken'

    assert !@issue.pending?
  end

  test 'increment script counter on create' do
    script = @issue.script

    assert_difference 'script.reload.active_issues_count' do
      @issue.dup.save!
    end
  end

  test 'decrement script counter on status closed' do
    script = @issue.script

    assert_difference 'script.reload.active_issues_count', -1 do
      @issue.update! status: 'closed'
    end
  end

  test 'no change script counter on status taken' do
    script = @issue.script

    assert_no_difference 'script.reload.active_issues_count' do
      @issue.update! status: 'taken'
    end
  end

  test 'decrement script counter on destroy' do
    script = @issue.script

    assert_difference 'script.reload.active_issues_count', -1 do
      @issue.destroy!
    end
  end

  test 'not decrement script counter on closed destroy' do
    script = @issue.script

    @issue.update! status: 'closed'

    assert_no_difference 'script.reload.active_issues_count' do
      @issue.destroy!
    end
  end
end

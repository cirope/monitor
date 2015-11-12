require 'test_helper'

class IssuesHelperTest < ActionView::TestCase
  test 'status' do
    @issue = issues :ls_on_atahualpa_not_well

    assert_respond_to status, :each
  end

  test 'issue status' do
    assert_match /label-default/, issue_status('pending')
    assert_match /label-warning/, issue_status('taken')
    assert_match /label-success/, issue_status('closed')
  end

  test 'subscriptions' do
    @issue = issues :ls_on_atahualpa_not_well

    assert_equal @issue.subscriptions, subscriptions

    @issue = Issue.new

    assert_equal 1, subscriptions.size
    assert subscriptions.all?(&:new_record?)
  end

  test 'comments' do
    @issue = issues :ls_on_atahualpa_not_well

    assert_equal 1, comments.size
    assert comments.all?(&:new_record?)
  end
end

require 'test_helper'

class Issues::BoardHelperTest < ActionView::TestCase
  test 'board session' do
    assert_kind_of Array, board_session
  end

  test 'issue validation error' do
    issue = issues :ls_on_atahualpa_not_well
    session[:board_issue_errors] = nil

    assert_nil issue_validation_errors(issue)

    session[:board_issue_errors] = { issue.id => ['Error'] }

    assert_match 'Error', issue_validation_errors(issue)

    session[:board_issue_errors] = nil
  end
end

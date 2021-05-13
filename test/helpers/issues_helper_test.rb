# frozen_string_literal: true

require 'test_helper'

class IssuesHelperTest < ActionView::TestCase
  teardown do
    PaperTrail.request.whodunnit = nil
  end

  test 'issue index path' do
    skip
  end

  test 'issue actions cols' do
    assert_kind_of Integer, issue_actions_cols
  end

  test 'convert issues' do
    skip
  end

  test 'grouped issue stats' do
    skip
  end

  test 'issue stats totals' do
    skip
  end

  test 'status with current user' do
    PaperTrail.request.whodunnit = users(:franco).id

    @issue = issues :ls_on_atahualpa_not_well

    assert_respond_to status, :each
  end

  test 'status without current user' do
    @issue = issues :ls_on_atahualpa_not_well

    assert_respond_to status, :each
  end

  test 'issue status' do
    assert_match /badge-secondary/, issue_status('pending')
    assert_match /badge-warning/, issue_status('taken')
    assert_match /badge-success/, issue_status('closed')
  end

  test 'subscriptions' do
    @issue = issues :ls_on_atahualpa_not_well

    assert_equal @issue.subscriptions, subscriptions

    @issue = Issue.new

    assert_equal 1, subscriptions.size
    assert subscriptions.all?(&:new_record?)
  end

  test 'taggings' do
    @issue = issues :ls_on_atahualpa_not_well

    assert_equal @issue.taggings, issue_taggings

    @issue = Issue.new

    assert_equal 1, issue_taggings.size
    assert issue_taggings.all?(&:new_record?)
  end

  test 'comments' do
    @issue = issues :ls_on_atahualpa_not_well

    assert_equal 1, comments.size
    assert comments.all?(&:new_record?)
  end

  test 'is in board?' do
    issue = issues :ls_on_atahualpa_not_well

    assert !is_in_board?(issue)

    session[:board_issues] = [issue.id]

    assert is_in_board?(issue)

    session[:board_issues] = nil
  end

  test 'link add to board' do
    issue         = issues :ls_on_atahualpa_not_well
    @virtual_path = 'issues.issue'

    assert_match 'data-method="post"', link_to_add_to_board(issue)
  end

  test 'link remove from board' do
    issue         = issues :ls_on_atahualpa_not_well
    @virtual_path = 'issues.issue'

    assert_match 'data-method="delete"', link_to_remove_from_board(issue)
  end

  test 'link add all to board' do
    @script       = scripts :ls
    @virtual_path = 'issues.index'

    assert_match 'data-method="post"', link_to_add_all_to_board
  end

  test 'link remove all from board' do
    @script       = scripts :ls
    @virtual_path = 'issues.index'

    assert_match 'data-method="delete"', link_to_remove_all_from_board
  end

  test 'link to export data' do
    @issue        = issues :ls_on_atahualpa_not_well
    @virtual_path = 'issues.show'

    assert_match /href=".*"/, link_to_export_data
  end

  test 'limited issue form edition' do
    @issue = issues :ls_on_atahualpa_not_well

    assert !limited_issue_form_edition?

    @current_user = users :god

    assert limited_issue_form_edition?
  end

  private

    def board_session
      session[:board_issues] ||= []
    end

    def filter_params
      {}
    end

    def current_user
      @current_user ||= users :franco
    end
end

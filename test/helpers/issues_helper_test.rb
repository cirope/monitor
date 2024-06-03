# frozen_string_literal: true

require 'test_helper'

class IssuesHelperTest < ActionView::TestCase
  include HomeHelper

  teardown do
    PaperTrail.request.whodunnit = nil
  end

  test 'issue index path' do
    skip
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
    issue = Issue.new status: 'pending'

    assert_match /bg-secondary/, issue_status(issue)

    issue.status = 'taken'

    assert_match /bg-warning/, issue_status(issue)

    issue.status = 'closed'

    assert_match /bg-success/, issue_status(issue)

    issue.tags << Tag.new(name: 'test', style: 'danger', final: true)

    assert_match /bg-danger/, issue_status(issue)
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

  test 'issue tagging options' do
    issue = issues :ls_on_atahualpa_not_well

    assert_kind_of Hash, issue_tagging_options(issue)
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

  test 'can edit status' do
    @issue = issues :ls_on_atahualpa_not_well

    assert can_edit_status?

    @current_user = users :god

    refute can_edit_status?
  end

  test 'link to api issues' do
    script = scripts :ls
    button = link_to_api_issues script.id

    assert_match script_api_issues_path(script_id: script.id), button
  end

  test 'link to download issues csv' do
    @script = scripts :ls
    button  = link_to_download_issues_csv

    assert_match script_issues_path(@script), button
  end

  test 'return orginal filter params' do
    def params
      ActionController::Parameters.new(
        { filter:
          { original_filter:
            { status: '', tags: '', description: '', user_id: '', comment: '', show: 'all', user: ''}.to_json } }
      )
    end

    original_filter_json = { status: '', tags: '', description: '', user_id: '', comment: '', show: 'all', user: ''}.to_json

    assert_equal JSON.parse(original_filter_json), filter_original_query_hash
  end

  test 'return filter query hash' do
    def params
      ActionController::Parameters.new({ filter: ActionController::Parameters.new })
    end

    expected_hash = { show: nil, user: nil }

    assert_equal expected_hash, filter_original_query_hash
  end

  test 'show owner label' do
    ticket = issues :ticket_script
    label  = show_owner_label ticket

    assert_match ticket.to_s, label
  end

  test 'link to issue owner' do
    ticket = issues :ticket_script
    link   = link_to_issue_owner ticket

    assert_match issue_script_path(ticket, ticket.owner), link

    ticket = issues :ticket_without_owner
    link   = link_to_issue_owner ticket

    assert_match new_issue_script_path(ticket), link
  end

  test 'submit issue label' do
    @issue = issues :ticket_script
    label  = submit_issue_label

    assert_equal I18n.t('helpers.submit.update', model: Ticket.model_name.human(count: 1)), label
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

    def issue_filter
      {}
    end
end

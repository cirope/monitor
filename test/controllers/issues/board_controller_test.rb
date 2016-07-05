require 'test_helper'

class Issues::BoardControllerTest < ActionController::TestCase
  setup do
    @issue = issues :ls_on_atahualpa_not_well
    request.env['HTTP_REFERER'] = root_url

    login
  end

  test 'should get index' do
    get :index, session: { board_issues: [@issue.id] }
    assert_response :success
    assert_select 'table tbody tr', session[:board_issues].size
    assert_select 'table tbody tr td', text: @issue.description
  end

  test 'should get empty index' do
    get :index
    assert_response :success
    assert_select 'table tbody', false
  end

  test 'should add issue to the board via xhr' do
    post :create, params: { filter: { id: @issue.id } }, xhr: true, as: :js
    assert_response :success
    assert_includes session[:board_issues], @issue.id
  end

  test 'should add issue to the board via filter' do
    post :create, params: { filter: { description: @issue.description } }
    assert_response :redirect
    assert_includes session[:board_issues], @issue.id
  end

  test 'should update issues' do
    session[:board_issues] = [@issue.id]

    patch :update, params: { issue: { description: 'Updated' } }, session: { board_issues: [@issue.id] }
    assert_redirected_to issues_board_url
    assert_equal 'Updated', @issue.reload.description
  end

  test 'should delete issue from board via xhr' do
    delete :destroy, params: { filter: { id: @issue.id } }, session: { board_issues: [@issue.id] }, xhr: true, as: :js
    assert_response :success
    assert session[:board_issues].exclude?(@issue.id)
  end

  test 'should delete issue from board via filter' do
    delete :destroy, params: { filter: { description: @issue.description } }, session: { board_issues: [@issue.id] }
    assert_response :redirect
    assert session[:board_issues].exclude?(@issue.id)
  end

  test 'should empty the board' do
    delete :empty, session: { board_issues: [@issue.id], board_issue_errors: { @issue.id => 'Error' } }
    assert_redirected_to dashboard_url
    assert_equal 0, session[:board_issues].size
    assert_equal 0, session[:board_issue_errors].size
  end
end

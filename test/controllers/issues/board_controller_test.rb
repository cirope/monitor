require 'test_helper'

class Issues::BoardControllerTest < ActionController::TestCase
  setup do
    @issue = issues :ls_on_atahualpa_not_well
    request.env['HTTP_REFERER'] = root_url

    login
  end

  teardown do
    session[:board_issues] = nil
  end

  test 'should get index' do
    session[:board_issues] = [@issue.id]

    get :index
    assert_response :success
    assert_not_nil assigns(:issues)
    assert_equal session[:board_issues].size, assigns(:issues).size
    assert_equal @issue.id, assigns(:issues).first.id
  end

  test 'should get empty index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:issues)
    assert_equal 0, assigns(:issues).size
  end

  test 'should add issue to the board via xhr' do
    xhr :post, :create, filter: { id: @issue.id }, format: :js
    assert_response :success
    assert_template 'issues/board/create'
    assert_includes session[:board_issues], @issue.id
  end

  test 'should add issue to the board via filter' do
    post :create, filter: { description: @issue.description }
    assert_redirected_to :back
    assert_includes session[:board_issues], @issue.id
  end

  test 'should update issues' do
    session[:board_issues] = [@issue.id]

    patch :update, issue: { description: 'Updated' }
    assert_redirected_to issues_board_url
    assert_equal 'Updated', @issue.reload.description
  end

  test 'should delete issue from board via xhr' do
    session[:board_issues] = [@issue.id]

    xhr :delete, :destroy, filter: { id: @issue.id }, format: :js
    assert_response :success
    assert_template 'issues/board/destroy'
    assert session[:board_issues].exclude?(@issue.id)
  end

  test 'should delete issue from board via filter' do
    session[:board_issues] = [@issue.id]

    delete :destroy, filter: { description: @issue.description }
    assert_redirected_to :back
    assert session[:board_issues].exclude?(@issue.id)
  end

  test 'should empty the board' do
    session[:board_issues]       = [@issue.id]
    session[:board_issue_errors] = { @issue.id => 'Error' }

    delete :empty
    assert_redirected_to dashboard_url
    assert_equal 0, session[:board_issues].size
    assert_equal 0, session[:board_issue_errors].size
  end
end

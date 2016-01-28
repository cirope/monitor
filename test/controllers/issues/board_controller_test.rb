require 'test_helper'

class Issues::BoardControllerTest < ActionController::TestCase
  setup do
    @issue = issues :ls_on_atahualpa_not_well

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

  test 'should get create' do
    post :create, issue_id: @issue.id, format: :js
    assert_response :success
    assert_template 'issues/board/create'
    assert_includes session[:board_issues], @issue.id
  end

  test 'should get delete' do
    session[:board_issues] = [@issue.id]

    delete :destroy, issue_id: @issue.id, format: :js
    assert_response :success
    assert_template 'issues/board/destroy'
    assert session[:board_issues].exclude?(@issue.id)
  end
end

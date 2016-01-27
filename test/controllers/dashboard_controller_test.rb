require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  setup do
    login
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:scripts)
  end

  test 'should get filtered index' do
    get :index, filter: { name: 'undefined' }
    assert_response :success
    assert_not_nil assigns(:scripts)
    assert assigns(:scripts).empty?
  end

  test 'should get filtered index using issue tags' do
    get :index, filter: { tags: tags(:important).name }
    assert_response :success
    assert_not_nil assigns(:scripts)
    assert assigns(:scripts).any?
  end
end

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
end

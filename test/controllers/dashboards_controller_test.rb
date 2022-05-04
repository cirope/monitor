# frozen_string_literal: true

require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase

  setup do
    @dashboard = dashboards :franco_default

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create dashboard' do
    user = users :franco

    assert_difference 'user.dashboards.count' do
      post :create, params: {
        dashboard: {
          name: 'New dashboard'
        }
      }
    end

    assert_redirected_to dashboard_url(user.dashboards.last)
  end

  test 'should show dashboard' do
    get :show, params: { id: @dashboard }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @dashboard }
    assert_response :success
  end

  test 'should update dashboard' do
    patch :update, params: {
      id:        @dashboard,
      dashboard: {
        name: 'Updated name'
      }
    }

    assert_redirected_to dashboard_url(@dashboard.reload)
    assert_equal 'Updated name', @dashboard.name
  end

  test 'should destroy dashboard' do
    assert_difference 'Dashboard.count', -1 do
      delete :destroy, params: { id: @dashboard }
    end

    assert_redirected_to dashboards_url
  end
end

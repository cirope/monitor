# frozen_string_literal: true

require 'test_helper'

class PanelsControllerTest < ActionController::TestCase

  setup do
    @panel     = panels :servers_overloaded
    @dashboard = @panel.dashboard

    login
  end

  test 'should get new' do
    get :new, params: { dashboard_id: @dashboard }

    assert_response :success
  end

  test 'should create panel' do
    assert_difference 'Panel.count' do
      post :create, params: {
        dashboard_id: @dashboard,
        panel: {
          title: 'New panel',
          function: 'count',
          output_type: 'pie'
        }
      }
    end

    assert_redirected_to @dashboard
  end

  test 'should get edit' do
    get :edit, params: { dashboard_id: @dashboard, id: @panel }

    assert_response :success
  end

  test 'should update panel' do
    patch :update, params: { dashboard_id: @dashboard, id: @panel, panel: { attr: 'value' } }

    assert_redirected_to @dashboard
  end

  test 'should destroy panel' do
    assert_difference 'Panel.count', -1 do
      delete :destroy, params: { dashboard_id: @dashboard, id: @panel }
    end

    assert_redirected_to @dashboard
  end
end

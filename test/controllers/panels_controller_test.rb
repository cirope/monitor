# frozen_string_literal: true

require 'test_helper'

class PanelsControllerTest < ActionController::TestCase

  setup do
    @panel     = panels :servers_overloaded
    @dashboard = @panel.dashboard

    login
  end

  test 'should get new' do
    get :new, params: { dashboard_id: @dashboard }, xhr: true, as: :js

    assert_response :success
  end

  test 'should create panel' do
    assert_difference 'Panel.count' do
      post :create, params: {
        dashboard_id: @dashboard,
        panel:        {
          title: 'New panel'
        }
      }, xhr: true, as: :js
    end

    assert_response :success
  end

  test 'should show panel' do
    get :show, params: { id: @panel }, xhr: true, as: :js

    assert_response :success
  end

  test 'should show panel for nil param' do
    get :show, params: { id: 'nil' }, xhr: true, as: :js

    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @panel }, xhr: true, as: :js

    assert_response :success
  end

  test 'should update panel' do
    patch :update, params: {
      id:    @panel,
      panel: { attr: 'value' }
    }, xhr: true, as: :js

    assert_response :success
  end

  test 'should destroy panel' do
    assert_difference 'Panel.count', -1 do
      delete :destroy, params: { id: @panel }, xhr: true, as: :js
    end

    assert_response :success
  end
end

# frozen_string_literal: true

require 'test_helper'

class RolesControllerTest < ActionController::TestCase

  setup do
    @role = roles :supervisor

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

  test 'should create role' do
    assert_difference 'Role.count' do
      post :create, params: {
        role: {
          name: 'New Role', description: 'New Role', type: 'supervisor',
          permissions_attributes: [
            {
              section: 'Issue',
              read: true,
              edit: true,
              remove: true
            }
          ],
        }
      }
    end

    assert_redirected_to role_url(Role.last)
  end

  test 'should show role' do
    get :show, params: { id: @role }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @role }
    assert_response :success
  end

  test 'should update role' do
    patch :update, params: {
      id: @role,
      role: { type: 'guest' }
    }

    assert_redirected_to role_url(@role)
  end

  test 'should destroy role' do
    assert_difference 'Role.count', -1 do
      delete :destroy, params: { id: @role }
    end

    assert_redirected_to roles_url
  end
end

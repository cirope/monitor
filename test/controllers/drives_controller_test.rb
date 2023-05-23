# frozen_string_literal: true

require 'test_helper'

class DrivesControllerTest < ActionController::TestCase

  setup do
    @drive = drives :drive_config

    login user: users(:god)

    Current.account = send 'public.accounts', :default
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create drive' do
    assert_difference 'Drive.count' do
      post :create, params: {
        drive: {
          name: 'New Drive',
          provider: 'onedrive',
          client_id: 'new_client_id',
          client_secret: 'new_client_secret',
          tenant_id: 'new_tenant_id',
          drive_id: 'new_drive_id'
        }
      }
    end

    assert_redirected_to Drive.last.provider_auth_url
  end

  test 'should show drive' do
    get :show, params: { id: @drive }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @drive }
    assert_response :success
  end

  test 'should update drive and redirect to authorization' do
    @drive.send :create_section

    patch :update, params: {
      id: @drive, drive: { client_id: 'client_id_updated' }
    }

    assert_redirected_to @drive.reload.provider_auth_url
  end

  test 'should destroy drive' do
    assert_difference 'Drive.count', -1 do
      delete :destroy, params: { id: @drive }
    end

    assert_redirected_to drives_url
  end
end

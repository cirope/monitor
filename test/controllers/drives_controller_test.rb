# frozen_string_literal: true

require 'test_helper'

class DrivesControllerTest < ActionController::TestCase

  setup do
    @drive = drives(:one)

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

  test 'should create drive' do
    assert_difference 'Drive.count' do
      post :create, params: {
        drive: {
          name: nil, provider: nil, client_id: nil, client_secret: nil, account: nil
        }
      }
    end

    assert_redirected_to drive_url(Drive.last)
  end

  test 'should show drive' do
    get :show, params: { id: @drive }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @drive }
    assert_response :success
  end

  test 'should update drive' do
    patch :update, params: {
      id: @drive,
      drive: { attr: 'value' }
    }

    assert_redirected_to drive_url(@drive)
  end

  test 'should destroy drive' do
    assert_difference 'Drive.count', -1 do
      delete :destroy, params: { id: @drive }
    end

    assert_redirected_to drives_url
  end
end

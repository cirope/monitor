# frozen_string_literal: true

require 'test_helper'

class EndpointsControllerTest < ActionController::TestCase

  setup do
    @endpoint = endpoints :dynamics

    login user: users(:god)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create endpoint' do
    assert_difference 'Endpoint.count' do
      post :create, params: {
        endpoint: {
          name: 'New endpoint',
          provider: 'dynamics',
          client_id: 'New client_id',
          client_secret: 'New client_secret',
          directory_id: 'New directory_id'
        }
      }
    end

    assert_redirected_to endpoint_url(Endpoint.last)
  end

  test 'should show endpoint' do
    get :show, params: { id: @endpoint }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @endpoint }
    assert_response :success
  end

  test 'should update endpoint' do
    patch :update, params: {
      id: @endpoint, endpoint: { provider: 'dynamics', client_id: 'Client ip updated' }
    }

    assert_redirected_to endpoint_url(@endpoint)
  end

  test 'should destroy endpoint' do
    assert_difference 'Endpoint.count', -1 do
      delete :destroy, params: { id: @endpoint }
    end

    assert_redirected_to endpoints_url
  end
end

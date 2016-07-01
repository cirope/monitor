require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  setup do
    @server = servers :atahualpa

    login users(:god)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:servers)
  end

  test 'should get filtered index for autocomplete' do
    get :index, q: @server.name, format: :json
    assert_response :success

    servers = assigns :servers
    assert_equal 1, servers.size
    assert_equal @server.name, servers.first.name
  end

  test 'should get filtered index' do
    get :index, filter: { name: 'undefined' }
    assert_response :success
    assert_not_nil assigns(:servers)
    assert assigns(:servers).empty?
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create server' do
    assert_difference 'Server.count' do
      post :create, server: {
        name: 'New server', hostname: @server.hostname, user: @server.user, password: @server.password
      }
    end

    assert_redirected_to server_url(assigns(:server))
  end

  test 'should show server' do
    get :show, id: @server
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @server
    assert_response :success
  end

  test 'should update server' do
    patch :update, id: @server, server: { name: 'Updated name' }
    assert_redirected_to server_url(assigns(:server))
  end

  test 'should not destroy server' do
    assert_no_difference 'Server.count' do
      delete :destroy, id: @server
    end

    assert_redirected_to server_url(@server)
  end

  test 'should destroy server' do
    @server = servers :gardelito

    assert_difference 'Server.count', -1 do
      delete :destroy, id: @server
    end

    assert_redirected_to servers_url
  end
end

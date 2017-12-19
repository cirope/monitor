require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  setup do
    @server = servers :atahualpa

    login users(:god)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get filtered index for autocomplete' do
    get :index, params: { q: @server.name }, as: :json
    assert_response :success

    servers = JSON.parse @response.body

    assert_equal 1, servers.size
    assert_equal @server.name, servers.first['name']
  end

  test 'should get filtered index' do
    get :index, params: { filter: { name: 'undefined' } }
    assert_response :success
    assert_select '.alert', text: I18n.t('servers.index.empty_search_html')
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create server' do
    assert_difference 'Server.count' do
      post :create, params: {
        server: {
          name: 'New server',
          hostname: @server.hostname,
          user: @server.user,
          password: @server.password
        }
      }
    end

    assert_redirected_to server_url(Server.last)
  end

  test 'should show server' do
    get :show, params: { id: @server }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @server }
    assert_response :success
  end

  test 'should update server' do
    patch :update, params: {
      id: @server,
      server: { name: 'Updated name' }
    }

    assert_redirected_to server_url(@server)
  end

  test 'should not destroy server' do
    assert_no_difference 'Server.count' do
      delete :destroy, params: { id: @server }
    end

    assert_redirected_to server_url(@server)
  end

  test 'should destroy server' do
    @server = servers :gardelito

    assert_difference 'Server.count', -1 do
      delete :destroy, params: { id: @server }
    end

    assert_redirected_to servers_url
  end
end

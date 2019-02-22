require 'test_helper'

class LdapsControllerTest < ActionController::TestCase
  setup do
    @ldap = ldaps :ldap_server

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

  test 'should create ldap' do
    assert_difference 'Ldap.count' do
      post :create, params: {
        ldap: {
          hostname: 'localhost',
          port: ENV['TRAVIS'] ? 3389 : 389,
          basedn: 'ou=people,dc=test,dc=com',
          filter: 'CN=*',
          login_mask: 'cn=%{user},%{basedn}',
          username_attribute: 'cn',
          name_attribute: 'givenname',
          lastname_attribute: 'sn',
          email_attribute: 'mail',
          roles_attribute: 'description',
          test_user: 'admin',
          test_password: 'admin123',
          role_guest: 'Guest',
          role_author: 'Author',
          role_supervisor: 'Supervisor',
          role_security: 'Security'
        }
      }
    end

    assert_redirected_to ldap_url(Ldap.last)
  end

  test 'should show ldap' do
    get :show, params: { id: @ldap }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @ldap }
    assert_response :success
  end

  test 'should update ldap' do
    patch :update, params: {
      id: @ldap,
      ldap: {
        username_attribute: 'updated',
        test_user: 'admin',
        test_password: 'admin123'
      }
    }
    assert_redirected_to ldap_url(@ldap)
  end

  test 'should destroy ldap' do
    assert_difference 'Ldap.count', -1 do
      delete :destroy, params: { id: @ldap }
    end

    assert_redirected_to ldaps_url
  end
end

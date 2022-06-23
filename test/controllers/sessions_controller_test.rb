# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @user = users :franco
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should ask for password' do
    destroy_ad_services

    assert_no_difference '@user.logins.count' do
      post :create, params: { username: @user.email }
    end

    assert_redirected_to signin_url
  end

  test 'should create a new session' do
    destroy_ad_services

    assert_difference '@user.logins.count' do
      post :create, params: { username: @user.email }

      @controller = AuthenticationsController.new

      post :create, params: { password: '123' }
    end

    assert_redirected_to home_url
    assert_equal @user.id, current_user.id
  end

  test 'should create a new session and redirect to previous url' do
    destroy_ad_services

    assert_difference '@user.logins.count' do
      post :create, params:  { username: @user.email },
                    session: { previous_url: schedules_url }

      @controller = AuthenticationsController.new

      post :create, params: { password: '123' }
    end

    assert_redirected_to schedules_url
    assert_equal @user.id, current_user.id
  end

  test 'should create a new session via LDAP' do
    @user.update! username: 'admin'

    assert_difference '@user.logins.count' do
      post :create, params: { username: @user.username }

      @controller = AuthenticationsController.new

      post :create, params: { password: 'admin123' }
    end

    assert_redirected_to home_url
    assert_equal @user.id, current_user.id
  end

  test 'should not create a new session with correct username' do
    destroy_ad_services

    assert_no_difference '@user.logins.count' do
      assert_difference '@user.fails.count' do
        post :create, params: { username: @user.email }

        @controller = AuthenticationsController.new

        post :create, params: { password: 'wrong' }
      end
    end

    assert_response :success
    assert_nil current_user
  end

  test 'should redirect to signin_url with incorrect username' do
    destroy_ad_services

    assert_no_difference '@user.logins.count' do
      post :create, params: { username: 'not_exist' }
    end

    assert_redirected_to signin_url
    assert_nil current_user
  end

  test 'should redirect to saml sessions' do
    Ldap.default.destroy!

    assert_no_difference '@user.logins.count' do
      post :create, params: { username: 'franco' }
    end

    assert_redirected_to [
      :new,
      :saml_session,
      tenant_name: current_account.tenant_name
    ]
    assert_nil current_user
  end

  test 'should get destroy' do
    login = logins :franco

    @controller.send(:cookies).encrypted[:token] = @user.auth_token

    assert_not_nil current_user

    delete :destroy, session: { login_id: login.id }

    assert_redirected_to root_url
    assert_nil current_user
    assert_not_nil login.reload.closed_at
  end

  private

    def current_user
      @controller.send :current_user
    end

    def current_account
      @controller.send :current_account
    end

    def destroy_ad_services
      Ldap.default.destroy!
      Saml.default.destroy!
    end
end

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

  test 'should create a new session' do
    Ldap.default.destroy!

    assert_difference '@user.logins.count' do
      post :create, params: { username: @user.email, password: '123' }
    end

    assert_redirected_to home_url
    assert_equal @user.id, current_user.id
  end

  test 'should create a new session and redirect to previous url' do
    Ldap.default.destroy!

    assert_difference '@user.logins.count' do
      post :create, params:  { username: @user.email, password: '123' },
                    session: { previous_url: schedules_url }
    end

    assert_redirected_to schedules_url
    assert_equal @user.id, current_user.id
  end

  test 'should create a new session via LDAP' do
    @user.update! username: 'admin'

    assert_difference '@user.logins.count' do
      post :create, params: { username: @user.username, password: 'admin123' }
    end

    assert_redirected_to home_url
    assert_equal @user.id, current_user.id
  end

  test 'should not create a new session with correct user_name' do
    Ldap.default.destroy!

    assert_no_difference '@user.logins.count' do
      assert_difference 'Fail.all.count' do
        post :create, params: { username: @user.email, password: 'wrong' }
      end
    end

    assert_response :success
    assert_nil current_user
    assert_equal 1, Fail.where(user_id: @user.id).count
  end

  test 'should not create a new session with incorrect user_name' do
    Ldap.default.destroy!

    assert_no_difference '@user.logins.count' do
      assert_difference 'Fail.all.count' do
        post :create, params: { username: 'not_exist', password: 'wrong' }
      end
    end

    assert_response :success
    assert_nil current_user
    assert Fail.all.all? { |fail| fail.user.blank? }
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
end

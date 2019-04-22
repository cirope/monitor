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

    post :create, params: { username: @user.email, password: '123' }

    assert_redirected_to home_url
    assert_equal @user.id, current_user.id
  end

  test 'should create a new session and redirect to previous url' do
    Ldap.default.destroy!

    post :create,
      params:  { username: @user.email, password: '123' },
      session: { previous_url: schedules_url }

    assert_redirected_to schedules_url
    assert_equal @user.id, current_user.id
  end

  test 'should create a new session via LDAP' do
    @user.update! username: 'admin'

    post :create, params: { username: @user.username, password: 'admin123' }

    assert_redirected_to home_url
    assert_equal @user.id, current_user.id
  end

  test 'should not create a new session' do
    Ldap.default.destroy!

    post :create, params: { username: @user.email, password: 'wrong' }

    assert_response :success
    assert_nil current_user
  end

  test 'should get destroy' do
    @controller.send(:cookies).encrypted[:token] = @user.auth_token

    assert_not_nil current_user

    delete :destroy

    assert_redirected_to root_url
    assert_nil current_user
  end

  private

    def current_user
      @controller.send :current_user
    end
end

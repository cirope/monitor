# frozen_string_literal: true

require 'test_helper'

class RecordsControllerTest < ActionController::TestCase
  setup do
    @login = logins :franco
    @fail  = fails :fail_default

    login
  end

  test 'should get the login index' do
    get :index, params: { kind: 'login' }
    assert_response :success
  end

  test 'should get the fail index' do
    get :index, params: { kind: 'fail' }
    assert_response :success
  end

  test 'should get an login index filtered by date' do
    get :index, params: {
      kind: 'login',
      date: '02/07/2021 0:00 - 02/07/2021 23:55'
    }
    assert_response :success
  end

  test 'should get an login index filtered by user' do
    get :index, params: {
      kind: 'login',
      user: 'fra'
    }
    assert_response :success
  end

  test 'should get an fail index filtered by date' do
    get :index, params: {
      kind: 'fail',
      date: '02/07/2021 0:00 - 02/07/2021 23:55'
    }
    assert_response :success
  end

  test 'should get an fail index filtered by user' do
    get :index, params: {
      kind: 'fail',
      user: 'fra'
    }
    assert_response :success
  end

  test 'should get an login index filtered by date and user' do
    get :index, params: {
      kind: 'login',
      date: '02/07/2021 0:00 - 02/07/2021 23:55',
      user: 'fra'
    }
    assert_response :success
  end

  test 'should get an fail index filtered by date and user' do
    get :index, params: {
      kind: 'fail',
      date: '02/07/2021 0:00 - 02/07/2021 23:55',
      user: 'fra'
    }
    assert_response :success
  end

  test 'should show login' do
    get :show, params: {
      kind: 'login',
      id: @login
    }
    assert_response :success
  end

  test 'should show fail' do
    get :show, params: {
      kind: 'fail',
      id: @fail
    }
    assert_response :success
  end
end

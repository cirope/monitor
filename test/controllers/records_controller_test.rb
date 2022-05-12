# frozen_string_literal: true

require 'test_helper'

class RecordsControllerTest < ActionController::TestCase
  setup do
    @login      = logins :franco
    @fail       = fails :fail_default
    @start_date = I18n.l 2.hours.ago, format: :compact
    @end_date   = I18n.l 2.hours.from_now, format: :compact

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

  test 'should get login index filtered by date and user' do
    get :index, params: {
      kind: 'login',
      date: "#{@start_date} - #{@end_date}",
      user: 'fra'
    }
    assert_response :success
  end

  test 'should get fail index filtered by date and user' do
    get :index, params: {
      kind: 'fail',
      date: "#{@start_date} - #{@end_date}",
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

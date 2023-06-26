# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  setup do
    login
  end

  test 'should get index with all views scripts issues' do
    schedule = schedules :ls_on_atahualpa
    script   = scripts :ls

    get :index
    assert_response :success

    assert_select 'td' do
      assert_select 'td:nth-child(1)', script.name
      assert_select 'td:nth-child(2)', "#{users(:franco).subscriptions.count}/0"
    end

    assert_select 'td', text: schedule.name, count: 0
  end

  test 'should get index with some views scripts issues' do
    Subscription.create! issue: issues(:ls_on_atahualpa_not_well_again),
                         user: users(:franco)

    schedule = schedules :ls_on_atahualpa
    script   = scripts :ls

    get :index
    assert_response :success

    assert_select 'td' do
      assert_select 'td:nth-child(1)', script.name
      assert_select 'td:nth-child(2)', "#{users(:franco).subscriptions.count}/#{users(:franco).views.count}"
    end

    assert_select 'td', text: schedule.name, count: 0
  end

  test 'should get index with none views scripts issues' do
    views(:franco_view_ls).delete

    schedule = schedules :ls_on_atahualpa
    script   = scripts :ls

    get :index
    assert_response :success

    assert_select 'td' do
      assert_select 'td:nth-child(1)', script.name
      assert_select 'td:nth-child(2)', "#{users(:franco).subscriptions.count}/#{users(:franco).subscriptions.count}"
    end

    assert_select 'td', text: schedule.name, count: 0
  end

  test 'should get index grouped by all views schedule' do
    schedule = schedules :ls_on_atahualpa
    script   = scripts :ls
    account  = send 'public.accounts', :default

    account.update! group_issues_by_schedule: true

    get :index
    assert_response :success
    assert_select 'td', text: schedule.name

    assert_select 'td' do
      assert_select 'td:nth-child(1)', schedule.name
      assert_select 'td:nth-child(2)', "#{users(:franco).subscriptions.count}/0"
    end

    assert_select 'td', text: script.name, count: 0
  end

  test 'should get index grouped by some views schedule' do
    Subscription.create! issue: issues(:ls_on_atahualpa_not_well_again),
                         user: users(:franco)

    schedule = schedules :ls_on_atahualpa
    script   = scripts :ls
    account  = send 'public.accounts', :default

    account.update! group_issues_by_schedule: true

    get :index
    assert_response :success
    assert_select 'td', text: schedule.name

    assert_select 'td' do
      assert_select 'td:nth-child(1)', schedule.name
      assert_select 'td:nth-child(2)', "#{users(:franco).subscriptions.count}/#{users(:franco).views.count}"
    end

    assert_select 'td', text: script.name, count: 0
  end

  test 'should get index grouped by none views schedule' do
    views(:franco_view_ls).delete

    schedule = schedules :ls_on_atahualpa
    script   = scripts :ls
    account  = send 'public.accounts', :default

    account.update! group_issues_by_schedule: true

    get :index
    assert_response :success
    assert_select 'td', text: schedule.name

    assert_select 'td' do
      assert_select 'td:nth-child(1)', schedule.name
      assert_select 'td:nth-child(2)', "#{users(:franco).subscriptions.count}/#{users(:franco).subscriptions.count}"
    end

    assert_select 'td', text: script.name, count: 0
  end

  test 'should get filtered index' do
    get :index, params: {
      filter: { name: 'undefined', user: 'none', user_id: '1' }
    }
    assert_response :success
    assert_select '.alert', text: I18n.t('home.index.empty_search_html')
  end

  test 'should get filtered index using issue tags' do
    get :index, params: { filter: { show: 'all', tags: tags(:important).name } }
    assert_response :success

    assert_select 'table tbody tr', count: 1
  end

  test 'should get filtered index using issue user' do
    get :index, params: { filter: { show: 'all', user_id: users(:john).id } }
    assert_response :success
    assert_select 'table tbody tr', count: 1
  end

  test 'should get filtered index using issue data' do
    get :index, params: { filter: { show: 'all', data: { 'test': 'boom' }.to_json } }
    assert_response :success

    assert_select 'table tbody tr', count: 1
  end

  test 'should respond api issues by status' do
    get :api_issues_by_status, xhr: true

    url = api_v1_scripts_issues_by_status_url host: ENV['APP_HOST'],
                                              protocol: ENV['APP_PROTOCOL']

    assert_match url, response.body
  end
end

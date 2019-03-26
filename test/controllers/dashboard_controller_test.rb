# frozen_string_literal: true

require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  setup do
    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get filtered index' do
    get :index, {
      params: {
        filter: { name: 'undefined', user: 'none', user_id: '1' }
      }
    }
    assert_response :success
    assert_select '.alert', text: I18n.t('dashboard.index.empty_search_html')
  end

  test 'should get filtered index using issue tags' do
    get :index, params: { filter: { tags: tags(:important).name } }
    assert_response :success
    assert_select 'table tbody'
  end

  test 'should get filtered index using issue user' do
    get :index, params: { filter: { user_id: users(:john).id } }
    assert_response :success
    assert_select 'table tbody'
  end
end

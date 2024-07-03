# frozen_string_literal: true

require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    @account = send 'public.accounts', :default

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get filtered index' do
    get :index, params: { filter: { name: 'undefined' } }
    assert_response :success
    assert_select '.alert', text: I18n.t('accounts.index.empty_search_html')
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create account' do
    assert_difference ['Account.count', 'Membership.count'] do
      post :create, params: {
        account: {
          name:                     'New account',
          tenant_name:              'new_account',
          token_interval:           1,
          token_frequency:          'months',
          cleanup_runs_after:       1,
          cleanup_executions_after: 1,
          rows_per_page:            10
        }
      }
    end

    assert_redirected_to account_url(Account.last)
  end

  test 'should show account' do
    get :show, params: { id: @account }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @account }
    assert_response :success
  end

  test 'should update account' do
    patch :update, params: {
      id: @account,
      account: {
        name: 'New name'
      }
    }

    assert_redirected_to account_url(@account)
  end

  test 'new and create should be restricted to default account' do
    account = create_account
    user    = account.enroll users(:franco), copy_user: true

    account.switch do
      get :new

      assert_redirected_to root_url

      post :create, params: { account: { name: 'New name' } }

      assert_redirected_to root_url
    end
  end
end

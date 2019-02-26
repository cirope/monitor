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
          name:        'New account',
          tenant_name: 'new_account'
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

  test 'access should be restricted to default account' do
    account = Account.create! name: 'Test', tenant_name: 'test'
    user    = account.enroll users(:franco), copy_user: true

    account.switch do
      get :index

      assert_redirected_to root_url
    end
  end
end

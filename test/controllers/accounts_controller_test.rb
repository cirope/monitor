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

  test 'should destroy account' do
    assert_difference 'Account.count', -1 do
      delete :destroy, params: { id: @account }
    end

    assert_redirected_to accounts_url
  end
end

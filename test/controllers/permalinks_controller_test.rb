require 'test_helper'

class PermalinksControllerTest < ActionController::TestCase
  setup do
    @permalink = permalinks :link

    login
  end

  test 'should create permalink' do
    assert_difference 'Permalink.count' do
      post :create, params: {
        permalink: {
          issue_ids: [
            issues(:ls_on_atahualpa_not_well).id.to_s
          ]
        }
      }, as: :js
    end

    assert_response :success
    assert_equal 1, Permalink.last.issues.count
  end

  test 'should create permalink using session default' do
    assert_difference 'Permalink.count' do
      post :create, session: {
        board_issues: [
          issues(:ls_on_atahualpa_not_well).id.to_s
        ]
      }, as: :js
    end

    assert_response :success
    assert_equal 1, Permalink.last.issues.count
  end

  test 'should show permalink' do
    get :show, params: { id: @permalink }

    assert_response :success
  end

  test 'should show permalink with account' do
    account = send 'public.accounts', :default

    get :show, params: { id: @permalink, account_id: account }

    assert account.tenant_name, session[:tenant_name]
    assert_redirected_to permalink_url(@permalink)
  end
end

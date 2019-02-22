require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase

  setup do
    @membership = send 'public.memberships', :franco_default

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should show membership' do
    get :show, params: { id: @membership }
    assert_response :success
  end

  test 'should update membership' do
    account    = Account.create! name: 'Test', tenant_name: 'test'
    membership = account.enroll @membership.user, default: false

    patch :update, params: { id: membership }, xhr: true, as: :js

    assert_response :success
    assert membership.reload.default
  end
end

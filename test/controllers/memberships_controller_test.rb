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
    patch :update, params: {
      id: @membership,
      membership: { default: '0' }
    }

    assert_redirected_to membership_url(@membership)
    refute @membership.reload.default
  end
end

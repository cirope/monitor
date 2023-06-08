# frozen_string_literal: true

require 'test_helper'

class Memberships::SwitchControllerTest < ActionController::TestCase
  setup do
    @membership = send 'public.memberships', :franco_default

    login
  end

  test 'should create' do
    Saml.default.destroy!

    post :create, params: { membership_id: @membership }

    assert_redirected_to root_url
    assert_equal @membership.account.tenant_name, session[:tenant_name]
    assert_equal @membership.user.auth_token, cookies.encrypted[:token]
  end
end

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

  test 'should set rows per page' do
    Saml.default.destroy!

    account = send 'public.accounts', :default

    account.options['rows_per_page'] = 2

    assert account.update_column :options, account.options

    post :create, params: { membership_id: @membership }

    assert_redirected_to root_url
    assert_equal Kaminari.config.default_per_page, 2
  end
end

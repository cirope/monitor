# frozen_string_literal: true

require 'test_helper'

class Api::V1::AuthenticateUserTest < ActiveSupport::TestCase
  setup do
    @user    = users :franco
    @account = send 'public.accounts', :default
    @exp     = 1.month.from_now
  end

  test 'invalid without account' do
    call = Api::V1::AuthenticateUser.new(nil, @account, @exp).call

    assert call.result.blank?
    assert_equal call.errors[:token], [I18n.t('api.v1.authenticate_user.not_generate_token')]
  end

  test 'invalid without user' do
    call = Api::V1::AuthenticateUser.new(@user, nil, @exp).call

    assert call.result.blank?
    assert_equal call.errors[:token], [I18n.t('api.v1.authenticate_user.not_generate_token')]
  end

  test 'should return token without exp' do
    call = Api::V1::AuthenticateUser.new(@user, @account).call

    assert call.result.present?
  end

  test 'should return token with exp' do
    call = Api::V1::AuthenticateUser.new(@user, @account, @exp).call

    assert call.result.present?
  end
end

# frozen_string_literal: true

require 'test_helper'

class Api::V1::AuthorizeApiRequestTest < ActiveSupport::TestCase
  setup do
    @user    = users :franco
    @account = send 'public.accounts', :default
  end

  test 'invalid without header authorization' do
    call = Api::V1::AuthorizeApiRequest.new.call

    assert call.result.blank?
    assert_not_nil call.errors[:token],
                   [I18n.t('api.v1.authorize_api_request.errors.invalid_token'),
                    I18n.t('api.v1.authorize_api_request.errors.missing_token')]
  end

  test 'invalid token that dont have account' do
    token = JsonWebToken.encode(user_id: @user.id)

    call = Api::V1::AuthorizeApiRequest.new('Authorization' => token).call

    assert call.result.blank?
    assert_not_nil call.errors[:token],
                   [I18n.t('api.v1.authorize_api_request.errors.invalid_token')]
  end

  test 'invalid token that dont have user' do
    token = JsonWebToken.encode(account_id: @account.id)

    call = Api::V1::AuthorizeApiRequest.new('Authorization' => token).call

    assert call.result.blank?
    assert_not_nil call.errors[:token],
                   [I18n.t('api.v1.authorize_api_request.errors.invalid_token')]
  end

  test 'invalid token have invalid user' do
    last_user = User.last
    token     = JsonWebToken.encode(account_id: @account.id, user_id: last_user.id + 1)

    call = Api::V1::AuthorizeApiRequest.new('Authorization' => token).call

    assert call.result.blank?
    assert_not_nil call.errors[:token],
                   [I18n.t('api.v1.authorize_api_request.errors.invalid_token')]
  end

  test 'valid token and return user' do
    token = JsonWebToken.encode(account_id: @account.id, user_id: @user.id)

    call = Api::V1::AuthorizeApiRequest.new('Authorization' => token).call

    assert_equal @user, call.result
  end
end

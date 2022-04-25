# frozen_string_literal: true

require 'test_helper'

class JsonWebTokenTest < ActiveSupport::TestCase
  test 'should encode and decode token' do
    @account = send 'public.accounts', :default
    @user    = users :franco

    payload = { account_id: @account.id, user_id: @user.id }

    token = JsonWebToken.encode payload

    assert token.present?

    payload_result = JsonWebToken.decode token

    assert_equal payload_result, payload.merge(exp: 24.hours.from_now.to_i).stringify_keys
  end
end

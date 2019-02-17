require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  setup do
    @membership = memberships :franco_default
  end

  test 'blank attributes' do
    @membership.email = ''
    @membership.account = nil

    assert @membership.invalid?
    assert_error @membership, :email, :blank
    assert_error @membership, :account, :blank
  end

  test 'unique attributes' do
    membership = @membership.dup

    assert membership.invalid?
    assert_error membership, :email, :taken
  end
end

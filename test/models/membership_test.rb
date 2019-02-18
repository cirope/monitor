require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  setup do
    @membership = send 'public.memberships', :franco_default
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

  test 'all by username or email' do
    membership = Membership.all_by_username_or_email(@membership.email).take!

    assert_equal @membership, membership

    membership = Membership.all_by_username_or_email(@membership.email).take!

    assert_equal @membership, membership
  end
end

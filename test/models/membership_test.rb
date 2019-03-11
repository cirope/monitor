# frozen_string_literal: true

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

  test 'unique username' do
    membership = @membership.dup
    membership.email = 'other@email.com'

    assert membership.invalid?
    assert_error membership, :username, :taken
  end

  test 'all by username or email' do
    membership = Membership.all_by_username_or_email(@membership.email).take!

    assert_equal @membership, membership

    membership = Membership.all_by_username_or_email(@membership.email).take!

    assert_equal @membership, membership
  end

  test 'on destroy default membership mark other as default' do
    user    = @membership.user
    account = Account.create! name: 'Test', tenant_name: 'test'

    account.enroll user, copy_user: true

    other = user.memberships.where(default: false).take!

    @membership.destroy!

    assert other.reload.default
  end

  test 'on update default membership mark others as not default' do
    user    = @membership.user
    account = Account.create! name: 'Test', tenant_name: 'test'

    account.enroll user, copy_user: true

    other = user.memberships.where(default: false).take!

    other.update! default: true

    refute @membership.reload.default
  end
end

# frozen_string_literal: true

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  setup do
    @account = send 'public.accounts', :default
  end

  teardown do
    Current.account = nil
  end

  test 'blank attributes' do
    @account.name = ''
    @account.tenant_name = ''

    assert @account.invalid?
    assert_error @account, :name, :blank
    assert_error @account, :tenant_name, :blank
  end

  test 'unique attributes' do
    account = @account.dup

    assert account.invalid?
    assert_error account, :tenant_name, :taken
  end

  test 'attributes length' do
    @account.name = 'abcde' * 52
    @account.tenant_name = 'abcde' * 13

    assert @account.invalid?
    assert_error @account, :name, :too_long, count: 255
    assert_error @account, :tenant_name, :too_long, count: 63
  end

  test 'formatted attributes' do
    @account.tenant_name = 'x y'

    assert @account.invalid?
    assert_error @account, :tenant_name, :invalid

    @account.tenant_name = 'pg_xx'

    assert @account.invalid?
    assert_error @account, :tenant_name, :invalid
  end

  test 'destroy is not an option' do
    assert_no_difference 'Account.count' do
      @account.destroy
    end
  end

  test 'exluded attributes' do
    @account.tenant_name = 'public'

    assert @account.invalid?
    assert_error @account, :tenant_name, :exclusion
  end

  test 'included attributes' do
    @account.style = nil

    assert @account.invalid?
    assert_error @account, :style, :inclusion
  end

  test 'enroll' do
    @account.switch do
      assert_difference '@account.memberships.count' do
        assert_no_difference 'User.count' do
          @account.enroll users(:john)
        end
      end
    end
  end

  test 'enroll with copy' do
    account = Account.create! name: 'Test', tenant_name: 'test'
    user    = users :john

    account.switch do
      assert_difference ['account.memberships.count', 'User.count'] do
        account.enroll user, copy_user: true
      end
    end
  end

  test 'default by username or email' do
    user       = users :franco
    membership = send 'public.memberships', :franco_default

    account = Account.default_by_username_or_email user.username

    assert_equal membership.account, account

    account = Account.default_by_username_or_email user.email

    assert_equal membership.account, account
  end

  test 'on each' do
    assert_difference 'Issue.count', -1 do
      Account.on_each do |account|
        Issue.take.destroy!
      end
    end
  end

  test 'switch' do
    account = Account.create! name: 'Test', tenant_name: 'test'

    account.switch do
      assert User.all.empty?
      assert_equal account, Current.account
    end
  end

  test 'current' do
    skip
  end

  test 'by name' do
    skip
  end

  test 'by tenant name' do
    skip
  end
end

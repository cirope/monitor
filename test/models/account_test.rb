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
    @account.token_interval = ''
    @account.token_frequency = ''
    @account.cleanup_runs_after = ''
    @account.cleanup_executions_after = ''

    assert @account.invalid?
    assert_error @account, :name, :blank
    assert_error @account, :tenant_name, :blank
    assert_error @account, :token_interval, :blank
    assert_error @account, :token_frequency, :blank
    assert_error @account, :cleanup_runs_after, :blank
    assert_error @account, :cleanup_executions_after, :blank
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

  test 'numeric attributes' do
    @account.token_interval           = '1x'
    @account.cleanup_runs_after       = '1x'
    @account.cleanup_executions_after = '1x'

    assert @account.invalid?
    assert_error @account, :token_interval, :not_a_number
    assert_error @account, :cleanup_runs_after, :not_a_number
    assert_error @account, :cleanup_executions_after, :not_a_number
  end

  test 'attribute boundaries' do
    @account.token_interval           =  0
    @account.cleanup_runs_after       = -1
    @account.cleanup_executions_after = -1

    assert @account.invalid?
    assert_error @account, :token_interval, :greater_than_or_equal_to, count: 1
    assert_error @account, :cleanup_runs_after, :greater_than_or_equal_to, count: 0
    assert_error @account, :cleanup_executions_after, :greater_than_or_equal_to, count: 0
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
    @account.style           = nil
    @account.token_frequency = 'wrong'

    assert @account.invalid?
    assert_error @account, :style, :inclusion
    assert_error @account, :token_frequency, :inclusion
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
    account = create_account
    user    = users :john

    account.switch do
      assert_equal account.memberships.count, 0
      assert_equal User.count, 0
      assert_equal Role.count, 6
      assert_equal User.count, 0
    end

    account.enroll user, copy_user: true

    account.switch do
      assert_equal account.memberships.count, 1
      assert_equal User.count, 1
      assert_equal Role.count, 6
      assert_equal User.count, 1
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
    account = create_account

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

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  setup do
    @account = accounts :default
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

  test 'formatted attributes' do
    @account.tenant_name = 'x y'

    assert @account.invalid?
    assert_error @account, :tenant_name, :invalid

    @account.tenant_name = 'pg_xx'

    assert @account.invalid?
    assert_error @account, :tenant_name, :invalid
  end

  test 'exluded attributes' do
    @account.tenant_name = 'public'

    assert @account.invalid?
    assert_error @account, :tenant_name, :exclusion
  end
end

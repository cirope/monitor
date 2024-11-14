# frozen_string_literal: true

require 'test_helper'

class LdapTest < ActiveSupport::TestCase
  setup do
    @ldap = ldaps :ldap_server
  end

  teardown do
    Current.account = nil
  end

  test 'validates presence' do
    @ldap.hostname = ''
    @ldap.port = nil
    @ldap.basedn = ''
    @ldap.filter = ''
    @ldap.login_mask = ''
    @ldap.username_attribute = ''
    @ldap.name_attribute = ''
    @ldap.lastname_attribute = ''
    @ldap.email_attribute = ''
    @ldap.roles_attribute = ''

    assert @ldap.invalid?
    assert_error @ldap, :hostname, :blank
    assert_error @ldap, :port, :blank
    assert_error @ldap, :basedn, :blank
    assert_error @ldap, :filter, :blank
    assert_error @ldap, :login_mask, :blank
    assert_error @ldap, :username_attribute, :blank
    assert_error @ldap, :name_attribute, :blank
    assert_error @ldap, :lastname_attribute, :blank
    assert_error @ldap, :email_attribute, :blank
    assert_error @ldap, :roles_attribute, :blank
  end

  test 'validates formats' do
    @ldap.port = 'xx'
    @ldap.basedn = 'dc=name,noway'
    @ldap.username_attribute = '?'
    @ldap.name_attribute = '?'
    @ldap.lastname_attribute = '?'
    @ldap.email_attribute = '?'

    assert @ldap.invalid?
    assert_error @ldap, :port, :not_a_number
    assert_error @ldap, :basedn, :invalid
    assert_error @ldap, :username_attribute, :invalid
    assert_error @ldap, :name_attribute, :invalid
    assert_error @ldap, :lastname_attribute, :invalid
    assert_error @ldap, :email_attribute, :invalid
  end

  test 'validates port range' do
    @ldap.port = 0

    assert @ldap.invalid?
    assert_error @ldap, :port, :greater_than, count: 0

    @ldap.port = 65536

    assert @ldap.invalid?
    assert_error @ldap, :port, :less_than, count: 65536
  end

  test 'validates that can connect' do
    @ldap.test_user = 'admin'
    @ldap.test_password = 'wrong'

    assert @ldap.invalid?
    assert_equal @ldap.errors[:base], [I18n.t('messages.ldap_error')]

    @ldap.test_password = 'admin123'
    assert @ldap.valid?
  end

  test 'ldap bind' do
    ldap = @ldap.ldap 'admin', 'admin123'

    assert ldap.bind
  end

  test 'ldap no bind if wrong password' do
    ldap = @ldap.ldap 'admin', 'wrong'

    assert !ldap.bind
  end

  test 'import' do
    Current.account = send 'public.accounts', :default

    assert_nil User.where(email: 'juan@administrators.com').take
    assert_nil User.where(email: 'joe@administrators.com').take

    @ldap.import 'admin', 'admin123'

    user = User.where(email: 'juan@administrators.com').take

    assert_not_nil user
    assert user.guest?
    assert_equal user.data['origin'], 'ldap'
    assert_equal tags(:guest), user.tags.take

    user = User.where(email: 'joe@administrators.com').take

    assert_not_nil user
    assert_equal user.data['origin'], 'ldap'
    assert user.owner?
  end

  test 'default' do
    assert_not_nil Ldap.default
  end
end

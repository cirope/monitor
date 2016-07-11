require 'test_helper'

class LdapTest < ActiveSupport::TestCase
  setup do
    @ldap = ldaps :ldap_server
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
    @ldap.role_guest = ''
    @ldap.role_author = ''
    @ldap.role_supervisor = ''
    @ldap.role_security = ''

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
    assert_error @ldap, :role_guest, :blank
    assert_error @ldap, :role_author, :blank
    assert_error @ldap, :role_supervisor, :blank
    assert_error @ldap, :role_security, :blank
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

  test 'options' do
    @ldap.role_guest = 'Guest'
    @ldap.role_author = 'Author'
    @ldap.role_supervisor = 'Supervisor'
    @ldap.role_security = 'Security'

    assert_equal 'Guest', @ldap.role_guest
    assert_equal 'Author', @ldap.role_author
    assert_equal 'Supervisor', @ldap.role_supervisor
    assert_equal 'Security', @ldap.role_security
  end

  test 'import' do
    assert_nil User.where(email: 'juan@administrators.com').take

    tag = Tag.create! name: 'Guest role', kind: 'user'

    @ldap.import 'admin', 'admin123'

    user = User.where(email: 'juan@administrators.com').take

    assert_not_nil user
    assert_equal tag, user.tags.take
  end

  test 'default' do
    assert_not_nil Ldap.default
  end
end

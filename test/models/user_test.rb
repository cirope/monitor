require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users :franco

    Current.account = send 'public.accounts', :default
  end

  teardown do
    Current.account = nil
  end

  test 'should generate token on create' do
    @user = User.create!(
      name: @user.name,
      lastname: @user.lastname,
      email: 'new@user.com',
      username: 'new',
      password: '123',
      password_confirmation: '123'
    )

    assert @user.reload.auth_token.present?
  end

  test 'blank attributes' do
    @user.name = ''
    @user.lastname = ''
    @user.email = ''
    @user.role = ''

    assert @user.invalid?
    assert_error @user, :name, :blank
    assert_error @user, :lastname, :blank
    assert_error @user, :email, :blank
    assert_error @user, :role, :blank
  end

  test 'unique attributes' do
    @user.email = users(:john).email
    @user.username = users(:john).username

    assert @user.invalid?
    assert_error @user, :email, :taken
    assert_error @user, :username, :taken
  end

  test 'email format' do
    @user.email = 'bad_email'

    assert @user.invalid?
    assert_error @user, :email, :invalid
  end

  test 'email downcase and strip' do
    @user.email = ' FRANCOCatena@gmail.com '

    assert @user.valid?
    assert_equal 'francocatena@gmail.com', @user.email
  end

  test 'attributes length' do
    @user.name = 'abcde' * 52
    @user.lastname = 'abcde' * 52
    @user.email = 'abcde' * 52
    @user.role = 'abcde' * 52
    @user.username = 'abcde' * 52

    assert @user.invalid?
    assert_error @user, :name, :too_long, count: 255
    assert_error @user, :lastname, :too_long, count: 255
    assert_error @user, :email, :too_long, count: 255
    assert_error @user, :role, :too_long, count: 255
    assert_error @user, :username, :too_long, count: 255
  end

  test 'included attributes' do
    @user.role = 'wrong'

    assert @user.invalid?
    assert_error @user, :role, :inclusion
  end

  test 'username globally taken on create' do
    account = Account.create! name: 'Test', tenant_name: 'test'

    account.switch do
      user       = @user.dup
      user.email = 'other@email.com'

      refute user.save
      assert_error user, :username, :globally_taken
    end
  end

  test 'username globally taken on update' do
    account  = Account.create! name: 'Test', tenant_name: 'test'
    user     = account.enroll @user, copy_user: true
    username = users(:eduardo).username

    account.switch do
      user.username = username

      assert user.invalid?
      assert_error user, :username, :globally_taken
    end
  end

  test 'email globally taken' do
    account = Account.create! name: 'Test', tenant_name: 'test'
    user    = account.enroll @user, copy_user: true
    email   = users(:eduardo).email

    account.switch do
      user.email = email

      assert user.invalid?
      assert_error user, :email, :globally_taken
    end
  end

  test 'guest?' do
    @user.role = 'guest'
    assert @user.guest?

    @user.role = 'author'
    assert !@user.guest?
  end

  test 'password expired' do
    @user.password_reset_sent_at = Time.zone.now

    assert !@user.password_expired?

    @user.password_reset_sent_at = 3.hours.ago

    assert @user.password_expired?
  end

  test 'auth' do
    @user.update! username: 'admin'

    assert @user.auth('admin123') # LDAP

    Ldap.default.destroy!

    assert @user.auth('123') # Local auth
  end

  test 'search' do
    users = User.search query: @user.name

    assert users.present?
    assert users.all? { |s| s.name =~ /#{@user.name}/ }
  end

  test 'by username or email' do
    user = User.by_username_or_email @user.username

    assert_equal @user, user

    user = User.by_username_or_email @user.email

    assert_equal @user, user
  end

  test 'hide' do
    assert_difference 'User.visible.count', -User.count do
      User.hide
    end
  end

  test 'update memberships on email change' do
    membership_ids = @user.memberships.ids

    assert membership_ids.any?

    @user.update! email: 'new@email.com'

    assert(Membership.where(id: membership_ids).all? do |membership|
      membership.email == @user.email
    end)
  end

  test 'update memberships on username change' do
    membership_ids = @user.memberships.ids

    assert membership_ids.any?

    @user.update! username: 'new_username'

    assert(Membership.where(id: membership_ids).all? do |membership|
      membership.username == @user.username
    end)
  end

  test 'delete only the current membership on hide' do
    account = Account.create! name: 'Test', tenant_name: 'test'

    assert_difference '@user.memberships.count' do
      account.enroll @user, copy_user: true
    end

    assert_difference ['User.visible.count', '@user.memberships.count'], -1 do
      @user.hide
    end

    assert Membership.where(email: @user.email).exists?
  end

  test 'create membership if hidden is updated to false' do
    assert_difference ['User.visible.count', '@user.memberships.count'], -1 do
      @user.hide
    end

    assert_difference ['User.visible.count', '@user.memberships.count'] do
      @user.update! hidden: false
    end
  end

  test 'by role' do
    skip
  end

  test 'by name' do
    skip
  end

  test 'by email' do
    skip
  end

  test 'by issues' do
    skip
  end
end

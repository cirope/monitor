# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

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
      password_confirmation: '123',
      role: roles(:supervisor),
      taggings_attributes: [
        { tag_id: tags(:recovery).id }
      ]
    )

    assert @user.reload.auth_token.present?
  end

  test 'blank attributes' do
    @user.name = ''
    @user.lastname = ''
    @user.email = ''

    assert @user.invalid?
    assert_error @user, :name, :blank
    assert_error @user, :lastname, :blank
    assert_error @user, :email, :blank
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
    @user.username = 'abcde' * 52

    assert @user.invalid?
    assert_error @user, :name, :too_long, count: 255
    assert_error @user, :lastname, :too_long, count: 255
    assert_error @user, :email, :too_long, count: 255
    assert_error @user, :username, :too_long, count: 255
  end

  test 'username globally taken on create' do
    account = create_account
    role    = @user.role.dup

    account.switch do
      role_new_account = Role.create role.attributes

      user       = @user.dup
      user.role  = role_new_account
      user.email = 'other@email.com'

      refute user.save
      assert_error user, :username, :globally_taken
    end
  end

  test 'username globally taken on update' do
    account  = create_account
    user     = account.enroll @user, copy_user: true
    username = users(:eduardo).username

    account.switch do
      user.username = username

      assert user.invalid?
      assert_error user, :username, :globally_taken
    end
  end

  test 'email globally taken' do
    account = create_account
    user    = account.enroll @user, copy_user: true
    email   = users(:eduardo).email

    account.switch do
      user.email = email

      assert user.invalid?
      assert_error user, :email, :globally_taken
    end
  end

  test 'password expired' do
    @user.password_reset_sent_at = Time.zone.now

    assert !@user.password_expired?

    @user.password_reset_sent_at = 3.hours.ago

    assert @user.password_expired?
  end

  test 'prepare password reset' do
    old_token = @user.password_reset_token

    @user.update! password_reset_sent_at: 3.days.ago
    @user.prepare_password_reset

    assert_not_equal old_token, @user.password_reset_token
    assert_equal Time.zone.today, @user.password_reset_sent_at.to_date
  end

  test 'permissions' do
    can_use_mine_filter = %w(manager author supervisor)

    can_use_mine_filter.each do |role|
      @user.role = roles role.to_sym

      assert @user.can_use_mine_filter?
    end

    (Role::TYPES - can_use_mine_filter).each do |role|
      @user.role = roles role.to_sym

      refute @user.can_use_mine_filter?
    end
  end

  test 'auth' do
    @user.update! username: 'admin'
    @user.taggings.clear

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
    account = create_account

    assert_difference '@user.memberships.count' do
      account.enroll @user, copy_user: true
    end

    assert_difference ['User.visible.count', '@user.memberships.count'], -1 do
      @user.hide
    end

    assert Membership.where(email: @user.email).exists?
    refute @user.visible?
  end

  test 'create membership if hidden is updated to false' do
    assert_difference ['User.visible.count', '@user.memberships.count'], -1 do
      @user.hide
    end

    refute @user.visible?

    assert_difference ['User.visible.count', '@user.memberships.count'] do
      @user.update! hidden: false
    end

    assert @user.visible?
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

  test 'Licensed user limit' do
    max_licensed_user = Rails.application.credentials.max_licensed_users_count[:global]
    licensed_user     = (users :eduardo)

    (max_licensed_user - User.licensed_user.count).times do |i|
      new_licensed_user                 = User.new
      new_licensed_user.email           = i.to_s + licensed_user.email
      new_licensed_user.username        = i.to_s + licensed_user.username
      new_licensed_user.name            = i.to_s + licensed_user.name
      new_licensed_user.lastname        = i.to_s + licensed_user.lastname
      new_licensed_user.role            = licensed_user.role
      new_licensed_user.password        = '123456'
      new_licensed_user.taggings        = licensed_user.taggings

      new_licensed_user.save!
    end

    new_licensed_user                 = User.new
    new_licensed_user.email           = 'test' + licensed_user.email
    new_licensed_user.username        = 'test' + licensed_user.username
    new_licensed_user.name            = 'test' + licensed_user.name
    new_licensed_user.lastname        = 'test' + licensed_user.lastname
    new_licensed_user.role            = licensed_user.role
    new_licensed_user.password        = '123456'
    new_licensed_user.taggings        = licensed_user.taggings

    assert_raise { new_licensed_user.save! }

    assert_error new_licensed_user, :base, :licensed_user_limit

    not_licensed_user = users :god
    not_licensed_user.role = roles :supervisor

    assert_raise { not_licensed_user.save! }

    assert_error not_licensed_user, :base, :licensed_user_limit
  end

  test 'notify issues' do
    Current.user = user = users :franco

    assert_equal 1, user.issues.count

    assert_enqueued_emails 1 do
      user.notify_issues user.issues
    end
  ensure
    Current.user = nil
  end

  test 'notify recent issues' do
    Current.user = user = users :franco

    assert_equal 1, user.issues.count

    assert_enqueued_emails 1 do
      user.notify_recent_issues 1.hour
    end
  ensure
    Current.user = nil
  end

  test 'notify recent issues all users' do
    assert_enqueued_emails 2 do
      User.notify_recent_issues_all_users 1.hour
    end
  end

  test 'should reject creation of user without recovery tag' do
    user = User.create(
      name:                  'Name',
      lastname:              'Lastname',
      email:                 'new@user.com',
      username:              'new',
      password:              '123',
      password_confirmation: '123',
      role:                  roles(:supervisor)
    )

    assert_error user, :tags, :recovery_blank
  end
end

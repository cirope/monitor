# frozen_string_literal: true

require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'roles' do
    assert_respond_to roles, :each
  end

  test 'user taggings' do
    @user = users :franco

    assert_equal @user.taggings, user_taggings

    @user = User.new

    assert_equal 1, user_taggings.size
    assert user_taggings.all?(&:new_record?)
  end

  test 'user actions columns' do
    assert_kind_of Integer, user_actions_columns
  end

  private

    def current_user
      users :franco
    end

    def ldap
      ldaps :ldap_server
    end
end

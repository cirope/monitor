require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'roles' do
    assert_respond_to roles, :each
  end

  test 'roles label' do
    assert_match /href/, roles_label
  end

  test 'user taggings' do
    @user = users :franco

    assert_equal @user.taggings, user_taggings

    @user = User.new

    assert_equal 1, user_taggings.size
    assert user_taggings.all?(&:new_record?)
  end
end

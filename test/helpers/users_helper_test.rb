require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'roles' do
    assert_respond_to roles, :each
  end

  test 'roles label' do
    assert_match /href/, roles_label
  end
end

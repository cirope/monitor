require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'roles' do
    assert_respond_to roles, :each
  end
end

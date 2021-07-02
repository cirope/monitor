# frozen_string_literal: true

require 'test_helper'

class RecordsHelperTest < ActionView::TestCase
  setup do
    @login             = logins :franco
    @fail_with_user    = fails :fail_franco_user 
    @fail_unknown_user = fails :fail_unknown_user
  end

  test 'records_kinds' do
    assert_respond_to record_kinds, :each
  end

  test 'should return the username of the login' do
    assert_equal 'franco', record_user_name(@login)
  end

  test 'should return the username of the fail' do
    assert_equal 'franco', record_user_name(@fail_with_user)
  end

  test 'should return the unknown username of the fail' do
    assert_equal 'unknown', record_user_name(@fail_unknown_user)
  end
end

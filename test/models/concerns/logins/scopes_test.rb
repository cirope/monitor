# frozen_string_literal: true

require 'test_helper'

class ScopeTest < ActiveSupport::TestCase
  setup do
    @login = logins :franco
  end

  test 'should return a login within the date range' do
    @login.update_attribute 'created_at', Time.now

    start_range_at  = (Time.now - 2.hours).strftime '%d/%m/%Y %H:%M'
    end_range_at    = (Time.now + 2.hours).strftime '%d/%m/%Y %H:%M'
    range_as_string = "#{start_range_at} - #{end_range_at}"

    assert_equal 1, Login.by_date(range_as_string).count
  end

  test 'should not return a login within the date range' do
    @login.update_attribute 'created_at', Time.now

    start_range_at  = (Time.now + 2.hours).strftime '%d/%m/%Y %H:%M'
    end_range_at    = (Time.now + 4.hours).strftime '%d/%m/%Y %H:%M'
    range_as_string = "#{start_range_at} - #{end_range_at}"

    assert_equal 0, Login.by_date(range_as_string).count
  end

  test 'should return a login with like username' do
    username_to_upper = @login.user.username.upcase

    assert_equal 1, Login.by_user(username_to_upper[0..2]).count
  end

  test 'should not return a login with like username' do
    assert_equal 0, Login.by_user('UKN').count
  end
end

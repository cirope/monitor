# frozen_string_literal: true

require 'test_helper'

class ScopeTest < ActiveSupport::TestCase
  setup do
    @fail = fails :fail_franco_user
  end

  test 'should return a fail within the date range' do
    @fail.update_attribute 'created_at', (Time.now - 1.year)

    start_range_at  = (Time.now - 1.year - 2.hours).strftime '%d/%m/%Y %H:%M'
    end_range_at    = (Time.now - 1.year + 2.hours).strftime '%d/%m/%Y %H:%M'
    range_as_string = "#{start_range_at} - #{end_range_at}"

    assert_equal 1, Fail.by_date(range_as_string).count
  end

  test 'should not return a fail within the date range' do
    @fail.update_attribute 'created_at', (Time.now - 1.year)

    start_range_at  = (Time.now - 1.year + 2.hours).strftime '%d/%m/%Y %H:%M'
    end_range_at    = (Time.now - 1.year + 4.hours).strftime '%d/%m/%Y %H:%M'
    range_as_string = "#{start_range_at} - #{end_range_at}"

    assert_equal 0, Fail.by_date(range_as_string).count
  end

  test 'should return a fail with like username' do
    username_to_upper = @fail.user.username.upcase

    assert_equal 1, Fail.by_user(username_to_upper[0..2]).count
  end

  test 'should not return a fail with like username' do
    assert_equal 0, Fail.by_user('UKN').count
  end
end

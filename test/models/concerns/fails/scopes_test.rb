# frozen_string_literal: true

require 'test_helper'

class ScopeTest < ActiveSupport::TestCase
  setup do
    @fail = fails :fail_franco_user
  end

  test 'should return a fail within the date range' do
    @fail.update_attribute 'created_at', 1.year.ago

    start_range_at  = I18n.l 1.year.ago - 2.hours, format: :compact
    end_range_at    = I18n.l 1.year.ago + 2.hours, format: :compact
    range_as_string = "#{start_range_at} - #{end_range_at}"

    assert_equal 1, Fail.by_date(range_as_string).count
  end

  test 'should not return a fail within the date range' do
    @fail.update_attribute 'created_at', 1.year.ago

    start_range_at  = I18n.l 1.year.ago + 2.hours, format: :compact
    end_range_at    = I18n.l 1.year.ago + 4.hours, format: :compact
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

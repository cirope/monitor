# frozen_string_literal: true

require 'test_helper'

class ScopeTest < ActiveSupport::TestCase
  setup do
    @login = logins :franco
  end

  test 'should return a login within the date range' do
    @login.update_attribute 'created_at', 1.year.ago

    start_range_at  = I18n.l 1.year.ago - 2.hours, format: :compact
    end_range_at    = I18n.l 1.year.ago + 2.hours, format: :compact
    range_as_string = "#{start_range_at} - #{end_range_at}"

    assert_equal 1, Login.by_date(range_as_string).count
  end

  test 'should not return a login within the date range' do
    @login.update_attribute 'created_at', 1.year.ago

    start_range_at  = I18n.l 1.year.ago + 2.hours, format: :compact
    end_range_at    = I18n.l 1.year.ago + 4.hours, format: :compact
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

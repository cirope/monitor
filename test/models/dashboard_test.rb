# frozen_string_literal: true

require 'test_helper'

class DashboardTest < ActiveSupport::TestCase
  setup do
    @dashboard = dashboards :franco_default
  end

  test 'blank attributes' do
    @dashboard.name = ''

    assert @dashboard.invalid?
    assert_error @dashboard, :name, :blank
  end

  test 'unique attributes' do
    dashboard = @dashboard.dup

    assert dashboard.invalid?
    assert_error dashboard, :name, :taken
  end

  test 'attributes length' do
    @dashboard.name = 'abcde' * 52

    assert @dashboard.invalid?
    assert_error @dashboard, :name, :too_long, count: 255
  end
end

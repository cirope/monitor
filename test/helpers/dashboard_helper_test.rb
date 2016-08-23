require 'test_helper'

class DashboardHelperTest < ActionView::TestCase
  test 'dashboard empty messages' do
    skip
  end

  test 'filter status' do
    assert_respond_to filter_status, :each
  end
end

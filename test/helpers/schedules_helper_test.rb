require 'test_helper'

class SchedulesHelperTest < ActionView::TestCase
  test 'frequency' do
    assert_kind_of Array, frequencies
  end

  test 'link to runs' do
    assert_match Run.model_name.human(count: 0), link_to_runs(Schedule.first)
  end
end

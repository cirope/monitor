require 'test_helper'

class SchedulesHelperTest < ActionView::TestCase
  test 'frequency' do
    assert_kind_of Array, frequencies
  end

  test 'schedule dependencies' do
    @schedule = schedules :ls_on_atahualpa

    assert_equal @schedule.dependencies, dependencies

    @schedule = Schedule.new

    assert_equal 1, dependencies.size
    assert dependencies.all?(&:new_record?)
  end

  test 'link to runs' do
    assert_match Run.model_name.human(count: 0), link_to_runs(Schedule.first)
  end
end

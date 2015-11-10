require 'test_helper'

class SchedulesHelperTest < ActionView::TestCase
  test 'frequency' do
    assert_kind_of Array, frequencies
  end

  test 'schedule jobs' do
    @schedule = schedules :ls_on_atahualpa

    assert_equal @schedule.jobs, jobs

    @schedule = Schedule.new

    assert_equal 1, jobs.size
    assert jobs.all?(&:new_record?)
  end

  test 'schedule taggings' do
    @schedule = schedules :ls_on_atahualpa

    assert_equal @schedule.taggings, schedule_taggings

    @schedule = Schedule.new

    assert_equal 1, schedule_taggings.size
    assert schedule_taggings.all?(&:new_record?)
  end

  test 'schedule dependencies' do
    @schedule = schedules :ls_on_atahualpa

    assert_equal @schedule.dependencies, dependencies

    @schedule = Schedule.new

    assert_equal 1, dependencies.size
    assert dependencies.all?(&:new_record?)
  end

  test 'schedule dispatchers' do
    @schedule = schedules :cd_root_on_atahualpa

    assert_equal @schedule.dispatchers, dispatchers

    @schedule = Schedule.new

    assert_equal 1, dispatchers.size
    assert dispatchers.all?(&:new_record?)
  end

  test 'link to runs' do
    assert_match Run.model_name.human(count: 0), link_to_runs(Schedule.first)
  end
end

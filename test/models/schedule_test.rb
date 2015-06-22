require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  def setup
    @schedule = schedules :ls_on_atahualpa
  end

  test 'create first run on creation' do
    schedule = @schedule.dup

    assert_difference ['Schedule.count', 'Run.count'] do
      schedule.save!
    end
  end

  test 'blank attributes' do
    @schedule.start = ''
    @schedule.script = nil
    @schedule.server = nil

    assert @schedule.invalid?
    assert_error @schedule, :start, :blank
    assert_error @schedule, :script, :blank
    assert_error @schedule, :server, :blank
  end

  test 'datetime attributes' do
    @schedule.start = '13/13/13'
    @schedule.end = '13/13/13'

    assert @schedule.invalid?
    assert_error @schedule, :start, :invalid_datetime
    assert_error @schedule, :end, :invalid_datetime
  end

  test 'start must be on or after now' do
    @schedule.start = 1.minute.ago

    assert @schedule.invalid?
    assert_error @schedule, :start, :on_or_after, restriction: I18n.l(Time.zone.now, format: :compact)
  end

  test 'end must be after start' do
    @schedule.end = @schedule.start - 1.day

    assert @schedule.invalid?
    assert_error @schedule, :end, :after, restriction: I18n.l(@schedule.start, format: :compact)
  end

  test 'numeric attributes' do
    @schedule.interval = '1x'

    assert @schedule.invalid?
    assert_error @schedule, :interval, :not_a_number
  end

  test 'attribute boundaries' do
    @schedule.interval = 0

    assert @schedule.invalid?
    assert_error @schedule, :interval, :greater_than, count: 0
  end

  test 'attribute inclusion' do
    @schedule.frequency = 'no_way'

    assert @schedule.invalid?
    assert_error @schedule, :frequency, :inclusion
  end
end

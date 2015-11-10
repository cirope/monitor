require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  def setup
    @schedule = schedules :ls_on_atahualpa
  end

  test 'create first run on creation' do
    schedule = @schedule.dup
    schedule.jobs = @schedule.jobs.map(&:dup)

    assert_not_equal schedule.jobs.length, 0

    assert_difference 'Schedule.count' do
      assert_difference 'Run.count', schedule.jobs.length do
        schedule.save!
      end
    end
  end

  test 'blank attributes' do
    @schedule.name = ''
    @schedule.start = ''

    assert @schedule.invalid?
    assert_error @schedule, :name, :blank
    assert_error @schedule, :start, :blank
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

    assert @schedule.valid? # only on create

    schedule = @schedule.dup
    schedule.start = 1.minute.ago

    assert schedule.invalid?
    assert_error schedule, :start, :on_or_after, restriction: I18n.l(Time.zone.now, format: :compact)
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

  test 'run?' do
    assert !@schedule.run?
  end

  test 'last run ok' do
    assert @schedule.last_run_ok?

    @schedule.runs.executed.last.update! status: 'error'

    assert !@schedule.last_run_ok?
  end

  test 'next date' do
    skip
  end

  test 'build next run' do
    runs = nil
    next_date = @schedule.send :next_date

    assert_difference '@schedule.runs.pending.count'  do
      runs = @schedule.build_next_runs
    end

    assert runs.all? { |run| run.scheduled_at.between?(next_date - 1.minute, next_date + 1.minute) }
  end

  test 'run' do
    assert_difference '@schedule.runs.count'  do
      assert_no_difference '@schedule.runs.pending.count'  do
        @schedule.run
      end
    end
  end

  test 'avoid build next run if schedule ended' do
    @schedule.update! start: 30.seconds.from_now, end: 1.minute.from_now

    assert_no_difference '@schedule.runs.pending.count'  do
      @schedule.build_next_runs
    end
  end

  test 'search' do
    schedules = Schedule.search query: @schedule.name

    assert schedules.present?
    assert schedules.all? { |s| s.name =~ /#{@schedule.name}/ }
  end

  test 'schedule' do
    skip
  end
end

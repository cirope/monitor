require 'test_helper'

class RunTest < ActiveSupport::TestCase
  setup do
    @run = runs :ls_on_atahualpa
  end

  test 'blank attributes' do
    @run.status = ''
    @run.scheduled_at = ''
    @run.job = nil

    assert @run.invalid?
    assert_error @run, :status, :blank
    assert_error @run, :scheduled_at, :blank
    assert_error @run, :job, :blank
  end

  test 'included attributes' do
    @run.status = 'no_way'

    assert @run.invalid?
    assert_error @run, :status, :inclusion
  end

  test 'date attributes' do
    @run.scheduled_at = '13/13/13'
    @run.started_at = '13/13/13'
    @run.ended_at = '13/13/13'

    assert @run.invalid?
    assert_error @run, :scheduled_at, :invalid_datetime
    assert_error @run, :started_at, :invalid_datetime
    assert_error @run, :ended_at, :invalid_datetime
  end

  test 'ok' do
    assert !@run.ok?

    @run.status = 'ok'

    assert @run.ok?
  end

  test 'by status' do
    skip
  end

  test 'by scheduled at' do
    skip
  end

  test 'by script name' do
    skip
  end

  test 'schedule' do
    skip
  end

  test 'execute triggers' do
    skip
  end
end

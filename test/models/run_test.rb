require 'test_helper'

class RunTest < ActiveSupport::TestCase
  def setup
    @run = runs :ls_on_atahualpa
  end

  test 'blank attributes' do
    @run.status = ''
    @run.scheduled_at = ''
    @run.schedule = nil

    assert @run.invalid?
    assert_error @run, :status, :blank
    assert_error @run, :scheduled_at, :blank
    assert_error @run, :schedule, :blank
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

  test 'date boundaries' do
    @run.scheduled_at = 1.minute.ago
    @run.started_at = 1.minute.ago
    @run.ended_at = 1.minute.ago

    assert @run.invalid?
    assert_error @run, :scheduled_at, :on_or_after, restriction: I18n.l(Time.zone.now, format: :compact)
    assert_error @run, :started_at, :on_or_after, restriction: I18n.l(Time.zone.now, format: :compact)
    assert_error @run, :ended_at, :on_or_after, restriction: I18n.l(Time.zone.now, format: :compact)
  end
end

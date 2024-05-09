# frozen_string_literal: true

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

  test 'canceled' do
    assert !@run.canceled?

    @run.status = 'canceled'

    assert @run.canceled?
  end

  test 'should be canceled' do
    assert !@run.should_be_canceled?

    run        = @run.dup
    run.status = 'running'

    run.save!

    assert @run.should_be_canceled?
  end

  test 'cancel run' do
    @run.cancel

    assert @run.reload.canceled?
  end

  test 'execute' do
    skip
  end

  test 'execute with series output' do
    result = {
      status: 'ok',
      stdout: {
        series: [
          {
            name:       'test2',
            identifier: 'user_2',
            timestamp:  1.days.ago,
            amount:     1.11
          },
          {
            name:       'test3',
            identifier: 'user_3',
            timestamp:  3.days.ago,
            amount:     3.33
          }
        ]
      }.to_json
    }

    assert_difference 'Serie.count', 2 do
      override_and_run_execute @run, result
    end

    # delete series key after success serie creation
    refute @run.reload.data.key? 'series'
  end

  test 'execute with malformed output' do
    result = {
      status: 'ok',
      stdout: {
        series: [
          {
            name:       'test2',
            identifier: 'user_2',
            timestamp:  1.days.ago,
            amount:     1.11
          },
          {
            name:       '',
            identifier: '',
            timestamp:  2.days.ago
          },
          {
            name:       'test3',
            identifier: 'user_3',
            timestamp:  3.days.ago,
            amount:     3.33
          }
        ]
      }.to_json
    }

    assert_difference 'Serie.count', 2 do
      override_and_run_execute @run, result
    end

    assert @run.reload.data.key? 'series'
  end

  test 'mark as running' do
    skip
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

  test 'scheduled' do
    skip
  end

  test 'overdue' do
    skip
  end

  test 'overdue by' do
    skip
  end

  test 'running' do
    skip
  end

  test 'canceled scope' do
    skip
  end

  test 'cancel' do
    skip
  end

  test 'kill' do
    skip
  end

  test 'force kill' do
    skip
  end

  test 'parse output errors for script' do
    run = runs :boom_on_atahualpa

    parsed_errors = run.parse_and_find_lines_with_errors_for :error
    script_errors = parsed_errors[run.script]

    assert_not_nil   script_errors
    assert_not_empty script_errors

    script_errors.each do |error|
      assert_equal 4, error[:line], error # 4: 4 * nil
    end
  end

  test 'parse output warnings for script' do
    run = runs :boom_on_atahualpa

    parsed_warnings = run.parse_and_find_lines_with_errors_for :warning
    script_warnings = parsed_warnings[run.script]

    assert_not_nil   script_warnings
    assert_not_empty script_warnings

    script_warnings.each do |warning|
      assert_equal 3, warning[:line], warning
    end
  end

  test 'parse output errors for script should not raise' do
    run = runs :boom_on_atahualpa

    run.update_column :stderr, 'something else'

    parsed_errors = run.parse_and_find_lines_with_errors_for :error

    assert_empty parsed_errors
  end

  test 'parse output errors for script with new core' do
    run = runs :boom_on_atahualpa

    # new core script
    scripts(:cd_root).update_column :core, true

    # Error will point to prev script now
    parsed_errors = run.parse_and_find_lines_with_errors_for :error

    assert_not_empty parsed_errors

    assert_nil parsed_errors[run.script]
  end

  test 'should cleanup runs' do
    account = send 'public.accounts', :default
    run     = runs :clean_ls_on_atahualpa

    account.switch do
      run.update_column :created_at, 2.days.ago

      assert_equal 4, Run.count

      Run.cleanup

      assert_equal 3, Run.count
    end
  end

  test 'should update script status' do
    run    = runs :clean_ls_on_atahualpa
    script = run.script

    assert_equal script.has_errors?, false

    run.update! status: 'error'

    assert_equal script.has_errors?, true
  end

  private

    def override_and_run_execute run, result
      stub_any_instance Schedule, :run?, true do
        stub_any_instance Server, :execute, result do
          assert run.execute
        end
      end
    end
end

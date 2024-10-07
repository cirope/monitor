# frozen_string_literal: true

require 'test_helper'

class ExecutionTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    @execution = executions :live_ls
  end

  test 'blank attributes' do
    @execution.script_id = nil
    @execution.server_id = nil
    @execution.user_id = nil

    assert @execution.invalid?
    assert_error @execution, :script, :blank
    assert_error @execution, :server, :blank
    assert_error @execution, :user, :blank
  end

  test 'schedule live execution after create' do
    execution = @execution.dup

    assert_enqueued_jobs 1 do
      execution.save!
    end
  end

  test 'status when killed can not be reverted' do
    @execution.killed!

    assert @execution.killed?

    @execution.success!

    refute @execution.success?
    assert @execution.killed?
  end

  test 'should cleanup executions' do
    account   = send 'public.accounts', :default
    execution = executions :live_ls

    execution.dup.save!

    account.switch do
      execution.update_column :created_at, 2.days.ago

      assert_equal 2, Execution.count

      Execution.cleanup

      assert_equal 1, Execution.count
    end
  end

  test 'run' do
    skip
  end

  test 'new line' do
    skip
  end

  test 'kill' do
    skip
  end

  test 'force kill' do
    skip
  end

  test 'measures' do
    skip
  end
end

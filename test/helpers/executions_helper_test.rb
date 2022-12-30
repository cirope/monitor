# frozen_string_literal: true

require 'test_helper'

class ExecutionsHelperTest < ActionView::TestCase
  test 'execution status' do
    assert_match /bg-success/, execution_status('success')
    assert_match /bg-danger/, execution_status('error')
    assert_match /bg-secondary/, execution_status('pending')
  end

  test 'link to force kill' do
    @virtual_path = 'executions.kill_actions'
    @execution    = executions :live_ls
    @script       = @execution.script

    assert_match 'skull', link_to_force_kill_execution
  end

  test 'link to kill' do
    @virtual_path = 'executions.kill_actions'
    @execution    = executions :live_ls
    @script       = @execution.script

    assert_match 'stop-circle', link_to_kill_execution
  end
end

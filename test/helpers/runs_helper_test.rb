# frozen_string_literal: true

require 'test_helper'

class RunsHelperTest < ActionView::TestCase
  test 'run status' do
    assert_match /bg-success/, run_status('ok')
    assert_match /bg-danger/, run_status('error')
    assert_match /bg-secondary/, run_status('pending')
  end

  test 'run output' do
    @run = Run.new(stdout: 'abcd' * 100)

    assert_match '...', run_output

    params[:full_output] = true

    assert_no_match '...', run_output
  end

  test 'filter run status' do
    assert_respond_to filter_run_status, :each
  end

  test 'link to force kill' do
    @virtual_path = 'runs.show'
    @run          = runs :ls_on_atahualpa

    assert_match 'skull', link_to_force_kill_run
  end

  test 'link to kill' do
    @virtual_path = 'runs.show'
    @run          = runs :ls_on_atahualpa

    assert_match 'stop-circle', link_to_kill_run
  end
end

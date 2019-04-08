# frozen_string_literal: true

require 'test_helper'

class RunsHelperTest < ActionView::TestCase
  test 'run status' do
    assert_match /label-success/, run_status('ok')
    assert_match /label-danger/, run_status('error')
    assert_match /label-default/, run_status('pending')
  end

  test 'run output' do
    @run = Run.new(output: 'abcd' * 100)

    assert_match '...', run_output

    params[:full_output] = true

    assert_no_match '...', run_output
  end

  test 'filter run status' do
    assert_respond_to filter_run_status, :each
  end

  test 'link to force kill' do
    @virtual_path = ''
    @run          = runs :ls_on_atahualpa

    assert_match 'glyphicon-fire', link_to_force_kill_run
  end

  test 'link to kill' do
    @virtual_path = ''
    @run          = runs :ls_on_atahualpa

    assert_match 'glyphicon-screenshot', link_to_kill_run
  end
end

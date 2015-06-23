require 'test_helper'

class RunsHelperTest < ActionView::TestCase
  test 'run status' do
    assert_match /label-success/, run_status('ok')
    assert_match /label-danger/, run_status('error')
    assert_match /label-default/, run_status('pending')
  end
end

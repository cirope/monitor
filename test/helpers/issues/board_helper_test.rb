require 'test_helper'

class Issues::BoardHelperTest < ActionView::TestCase
  test 'board session' do
    assert_kind_of Array, board_session
  end
end

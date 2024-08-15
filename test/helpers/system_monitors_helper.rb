# frozen_string_literal: true

require 'test_helper'

class SystemMonitorsHelperTest < ActionView::TestCase
  test 'link to kill' do
    @virtual_path = 'system_monitors.index'
    process       = SystemProcess.new 999
    link          = link_to_kill_process process

    assert_match t('.kill'), link
    assert_match 'data-method="delete"', link
  end
end

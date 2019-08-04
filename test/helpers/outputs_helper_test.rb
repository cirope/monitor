# frozen_string_literal: true

require 'test_helper'

class OutputsHelperTest < ActionView::TestCase
  test 'link to error line' do
    script = scripts :cd_root
    error  = {
      error: 'Test error',
      line:  1
    }

    assert_match script.id.to_s, link_to_error_line(script, error, valid: true)
  end
end

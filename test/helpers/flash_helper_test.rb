# frozen_string_literal: true

require 'test_helper'

class FlashHelperTest < ActionView::TestCase
  test 'flash message' do
    flash[:notice] = 'test notice'

    assert_equal 'test notice', flash_message

    flash.clear
    flash[:alert] = 'test alert'

    assert_equal 'test alert', flash_message
  end

  test 'flash classes' do
    flash[:notice] = 'test notice'

    assert_match 'alert-info', flash_classes

    flash.clear
    flash[:alert] = 'test alert'

    assert_match 'alert-danger', flash_classes
  end
end

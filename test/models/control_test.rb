# frozen_string_literal: true

require 'test_helper'

class ControlTest < ActiveSupport::TestCase
  setup do
    @control = controls :one
  end

  test 'blank attributes' do
    @control.attr = ''

    assert @control.invalid?
    assert_error @control, :attr, :blank
  end

  test 'unique attributes' do
    control = @control.dup

    assert control.invalid?
    assert_error control, :attr, :taken
  end
end

# frozen_string_literal: true

require 'test_helper'

class ControlOutputTest < ActiveSupport::TestCase
  setup do
    @control_output = control_outputs :one
  end

  test 'blank attributes' do
    @control_output.attr = ''

    assert @control_output.invalid?
    assert_error @control_output, :attr, :blank
  end

  test 'unique attributes' do
    control_output = @control_output.dup

    assert control_output.invalid?
    assert_error control_output, :attr, :taken
  end
end

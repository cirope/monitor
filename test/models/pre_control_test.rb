# frozen_string_literal: true

require 'test_helper'

class PreControlTest < ActiveSupport::TestCase
  setup do
    @pre_control = controls :first_pre_control_for_survey
  end

  test 'execute pre control and save control output' do
    assert_difference 'ControlOutput.count' do
      @pre_control.control
    end

    assert ControlOutput.last.ok?
  end

  test 'execute pre control and not update register' do
    @pre_control.callback = "controllable.issue.update_attribute(:description, 'test')"

    assert_difference 'ControlOutput.count' do
      @pre_control.control
    end

    assert ControlOutput.last.ok?
    assert_not_equal 'test', @pre_control.controllable.issue.reload.description
  end

  test 'execute pre control and raise error' do
    @pre_control.callback = "raise 'this is an error'"

    assert_difference 'ControlOutput.count' do
      @pre_control.control
    end

    last_output = ControlOutput.last

    assert last_output.error?
    assert_equal 'this is an error', last_output.output
  end
end

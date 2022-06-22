# frozen_string_literal: true

require 'test_helper'

class PostControlTest < ActiveSupport::TestCase
  setup do
    @post_control = controls :first_post_control_for_survey
  end

  test 'execute post control and save control output' do
    assert_difference 'ControlOutput.count' do
      @post_control.control
    end

    assert ControlOutput.last.ok?
  end

  test 'execute post control and update register' do
    @post_control.callback = "controllable.issue.update_attribute(:description, 'test')"

    assert_difference 'ControlOutput.count' do
      @post_control.control
    end

    assert ControlOutput.last.ok?
    assert_equal 'test', @post_control.controllable.issue.reload.description
  end

  test 'execute post control and raise error' do
    @post_control.callback = "raise 'this is an error'"

    assert_difference 'ControlOutput.count' do
      @post_control.control
    end

    last_output = ControlOutput.last

    assert last_output.error?
    assert_equal 'this is an error', last_output.output
  end
end

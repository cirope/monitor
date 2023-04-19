# frozen_string_literal: true

require 'test_helper'

class ControlTest < ActiveSupport::TestCase
  setup do
    @control = Control.new callback: 'true',
                           controllable: surveys(:survey_for_ls_on_atahualpa_not_well)
  end

  test 'invalid because callback is blank' do
    @control.callback = ''

    refute @control.valid?
    assert_error @control, :callback, :blank
  end

  test 'raise when execute control' do
    assert_raise do
      @control.control
    end
  end
end

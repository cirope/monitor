# frozen_string_literal: true

require 'test_helper'

class DropDownOptionTest < ActiveSupport::TestCase
  setup do
    @drop_down_option = drop_down_options :first_drop_down_option_drop_down_question
  end

  test 'invalid because value is blank' do
    @drop_down_option.value = ''

    refute @drop_down_option.valid?
    assert_error @drop_down_option, :value, :blank
  end

  test 'invalid because score is blank' do
    @drop_down_option.score = nil

    refute @drop_down_option.valid?
    assert_error @drop_down_option, :score, :blank
  end
end

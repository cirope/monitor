# frozen_string_literal: true

require 'test_helper'

class DropDownAnswerTest < ActiveSupport::TestCase
  setup do
    @drop_down_answer = answers :first_drop_down_answer
  end

  test 'should return partial' do
    assert_equal 'drop_down_answer', @drop_down_answer.partial
  end
end

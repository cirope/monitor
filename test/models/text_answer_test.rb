# frozen_string_literal: true

require 'test_helper'

class TextAnswerTest < ActiveSupport::TestCase
  setup do
    @text_answer = answers :first_text_answer
  end

  test 'invalid because response_text is blank' do
    @text_answer.response_text = ''

    refute @text_answer.valid?
    assert_error @text_answer, :response_text, :blank
  end

  test 'should return partial' do
    assert_equal 'text_answer', @text_answer.partial
  end
end

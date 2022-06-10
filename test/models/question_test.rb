# frozen_string_literal: true

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  setup do
    @question = Question.new title: 'Question?'
  end

  test 'invalid because title is blank' do
    @question.title = ''

    refute @question.valid?
    assert_error @question, :title, :blank
  end

  test 'raise when create answer' do
    assert_raise do
      @question.create_answer
    end
  end

  test 'raise when get results' do
    assert_raise do
      @question.results
    end
  end
end

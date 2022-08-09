# frozen_string_literal: true

require 'test_helper'

class TextQuestionTest < ActiveSupport::TestCase
  setup do
    @text_question = questions :text_question_survey_for_ls_on_atahualpa_not_well
  end

  test 'should create answer' do
    text_answer = @text_question.create_answer

    assert text_answer.new_record?
    assert_equal text_answer.question, @text_question
    assert_instance_of TextAnswer, text_answer
  end

  test 'should return results' do
    assert_equal @text_question.answers.map(&:response_text), @text_question.results
  end

  test 'should return results partial' do
    assert_equal 'text_question', @text_question.results_partial
  end
end

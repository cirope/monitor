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

  test 'execute post control answer and update question from question' do
    question = questions :drop_down_question_survey_for_ls_on_atahualpa_not_well

    question.post_controls
            .first
            .update_attribute :callback, "question.update_attribute(:title, 'test')"

    assert_difference 'ControlOutput.count' do
      question.post_control_answer question.answers.first
    end

    assert ControlOutput.last.ok?
    assert_equal 'test', question.reload.title
  end
end

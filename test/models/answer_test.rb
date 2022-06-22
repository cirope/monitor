# frozen_string_literal: true

require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test 'execute post control answer after save' do
    survey_answer = survey_answers :first_survey_answer
    question      = questions :text_question_survey_for_ls_on_atahualpa_not_well

    PostControl.create! controllable: question, callback: "question.update_attribute(:title, 'test')"

    assert_difference 'ControlOutput.count' do
      TextAnswer.create! question: question, survey_answer: survey_answer, response_text: 'response test'
    end

    assert ControlOutput.last.ok?
    assert_equal 'test', question.reload.title
  end
end
